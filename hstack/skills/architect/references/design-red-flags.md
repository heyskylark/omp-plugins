# Design red flags

Screen every candidate before synthesis. A red flag is a reason to revise or reject the shape, not a request to add another abstraction.

## Shallow module

A shallow module exposes a large interface while hiding little complexity. Prefer a simple interface backed by substantial behavior, not a deep call chain that scatters understanding across layers.

Look for callers coordinating several methods to complete one operation, public options exposing internal stages, or an interface that still requires learning its implementation.

## Information leakage

A representation, policy, or protocol detail appears in several modules, making a change require coordinated edits. Keep storage schemas, framework objects, and wire formats behind the boundary that owns them. Expose them only when they are deliberately part of the consumer's contract, not through incidental re-exports.

## Temporal decomposition

Modules organized only as load, validate, transform, and save stages can duplicate the same representation and invariants across boundaries. Group by domain knowledge and ownership. Methods invoked at different times can belong together when they protect the same decisions.

## Pass-through method

A method forwards the same arguments with the same shape while adding no policy or abstraction. Remove it or move responsibility to the module that can complete the operation. Keep a forwarding boundary when it adds meaningful policy, adaptation, or a distinct contract.

## Unowned state and escape hatches

Several actors mutate state without explicit consistency semantics, or callers must know internal ordering rules. Repeated casts, `any`, supposedly optional fields always required in practice, and repeated special cases can indicate that the shape does not encode its actual invariants. Check the pattern before condemning legitimate domain complexity.
