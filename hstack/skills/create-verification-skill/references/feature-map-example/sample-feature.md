# Sample feature

The user completes one named task through the application's normal surface and observes its durable result.

## Sub-features

- `sample-primary`: complete the main path.
- `sample-cancel`: leave without applying a mutation.
- `sample-persist`: reopen and observe the saved result.

## How to get to it (user POV)

- Start at the documented baseline screen or prompt.
- Use the visible control or command that names the feature.
- Reopen the same destination to check persistence.

## Driving it with <harness>

Preconditions: the parent skill's Launch and Doctor steps passed, and scratch state is disposable.

- **Primary action:** invoke the stable label, identifier, route, or command recorded from this repository; observe the expected result.
- **Cancel:** enter the flow, cancel through the user surface, and observe unchanged state.
- **Persistence:** relaunch or revisit through a second read-only view and observe the stored result.
- **Evidence:** retain action and result artifacts under the parent skill's evidence root with feature, platform, and build identifiers.

## Gotchas

- Coordinates and tab order are not stable selectors.
- A final screen without the triggering action is incomplete proof.
- A success message alone does not prove persistence.
- Cleanup must not delete evidence.
