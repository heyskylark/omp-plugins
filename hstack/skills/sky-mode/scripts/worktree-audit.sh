#!/usr/bin/env bash
# Usage: bash worktree-audit.sh [repo-path]. A safe bucket is a review candidate,
# not permission to delete. Cached remote refs may be stale. No fetch or removal.
set -u

repo="${1:-$(git rev-parse --show-toplevel 2>/dev/null)}"
[ -z "$repo" ] && { echo "not in a git repo; pass a repo path" >&2; exit 1; }
cd "$repo" || exit 1

audit=$(mktemp -d) || exit 1
trap 'rm -rf "$audit"' EXIT
if ! git worktree list --porcelain -z > "$audit/worktrees"; then
	exit 1
fi
main_wt=""
while IFS= read -r -d '' field; do
	case "$field" in worktree\ *) main_wt="${field#worktree }"; break ;; esac
done < "$audit/worktrees"
[ -z "$main_wt" ] && { echo "no worktrees found" >&2; exit 1; }

# Missing or capped PR inventory cannot establish that no open PR exists.
prs_known=no
if gh pr list --state all --limit 1000 --json number,state,headRefName > "$audit/prs" 2>/dev/null &&
	jq -e 'type == "array" and length < 1000 and all(.[]; (.number | type == "number") and (.headRefName | type == "string") and (.state == "OPEN" or .state == "CLOSED" or .state == "MERGED"))' "$audit/prs" >/dev/null 2>&1; then
	prs_known=yes
else
	echo "warn: PR inventory unavailable or capped; PR ownership requires manual review" >&2
fi
now=$(date +%s)
echo "warn: merge and remote columns use cached refs; LAST_CHAT is unknown until checked against known task sessions" >&2

emit_worktree() {
	local wt="$1" locked="$2"
	[ "$wt" = "$main_wt" ] && return
	local size head head_ts age merged dirty branch remote pr bucket row code
	local tracked=0 untracked=0 ignored=0 status_known=yes last=unknown
	size=$(du -sh "$wt" 2>/dev/null | cut -f1)
	[ -n "$size" ] || size="?"
	head=$(git -C "$wt" rev-parse HEAD 2>/dev/null) || head=""
	head_ts=$(git -C "$wt" log -1 --format='%ct' HEAD 2>/dev/null) || head_ts=0
	age="?"
	if [ "$head_ts" -gt 0 ] 2>/dev/null; then age="$(( (now - head_ts) / 86400 ))d"; fi
	merged="?"
	if [ -n "$head" ] && git rev-parse --verify origin/main >/dev/null 2>&1; then
		git merge-base --is-ancestor "$head" origin/main 2>/dev/null
		code=$?
		case "$code" in 0) merged=YES ;; 1) merged=no ;; esac
	fi

	if git -C "$wt" status --porcelain=v1 -z --untracked-files=all --ignored > "$audit/status" 2>/dev/null; then
		while IFS= read -r -d '' row; do
			code="${row:0:2}"
			case "$code" in
				'??') untracked=$((untracked + 1)) ;;
				'!!') ignored=$((ignored + 1)) ;;
				*) tracked=$((tracked + 1)) ;;
			esac
			case "$code" in *R*|*C*) IFS= read -r -d '' row || status_known=no ;; esac
		done < "$audit/status"
	else status_known=no; fi
	if [ "$status_known" = no ]; then dirty=unknown
	elif [ "$tracked" -gt 0 ]; then dirty="wip:$tracked;untracked:$untracked;ignored:$ignored"
	elif [ "$untracked" -gt 0 ]; then dirty="scratch:$untracked;ignored:$ignored"
	elif [ "$ignored" -gt 0 ]; then dirty="ignored:$ignored"
	else dirty=clean; fi

	branch=$(git -C "$wt" symbolic-ref --quiet --short HEAD 2>/dev/null) || branch=""
	if [ -z "$head" ]; then remote="?"
	elif [ -z "$branch" ]; then remote=detached
	elif git -C "$wt" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
		if [ "$(git -C "$wt" rev-parse "origin/$branch" 2>/dev/null)" = "$head" ]; then remote=pushed
		else
			code=$(git -C "$wt" rev-list --count "origin/$branch..HEAD" 2>/dev/null) || code="?"
			remote="ahead$code"
		fi
	else remote=no-remote; fi

	pr="?"
	if [ "$prs_known" = yes ] && [ -n "$branch" ]; then
		pr=$(jq -r --arg b "$branch" '[.[] | select(.headRefName == $b)] | sort_by(if .state == "OPEN" then 0 elif .state == "MERGED" then 1 else 2 end) | .[0] | if . == null then "-" else "#\(.number)/\(.state)" end' "$audit/prs" 2>/dev/null) || pr="?"
	fi
	if [ "$locked" = yes ]; then bucket=hold-locked
	elif [ "$status_known" = no ] || [ -z "$head" ] || [ "$pr" = "?" ] || [ "$size" = "?" ]; then bucket=hold-unknown
	elif [ "$tracked" -gt 0 ]; then bucket=hold-wip
	elif [[ "$pr" == */OPEN ]]; then bucket=hold-open-pr
	elif [ "$untracked" -gt 0 ] || [ "$ignored" -gt 0 ]; then bucket=review
	elif [ "$merged" = YES ] || [[ "$pr" == */MERGED ]]; then bucket=safe
	else bucket=review; fi

	wt="${wt//$'\t'/\\t}"
	wt="${wt//$'\n'/\\n}"
	printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
		"$size" "$age" "$merged" "$dirty" "$remote" "$pr" "$last" "$bucket" "$wt"
}

printf "SIZE\tAGE\tMERGED\tDIRTY\tREMOTE\tPR\tLAST_CHAT\tBUCKET\tWORKTREE\n"
wt=""; locked=no
while IFS= read -r -d '' field; do
	case "$field" in
		worktree\ *) wt="${field#worktree }" ;;
		locked|locked\ *) locked=yes ;;
		'')
			if [ -n "$wt" ]; then emit_worktree "$wt" "$locked"; fi
			wt=""; locked=no ;;
	esac
done < "$audit/worktrees" | sort -t$'\t' -k1,1rh
