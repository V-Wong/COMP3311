# Closures and Minimal Covers
## Closures
A closure ``F+`` is the **largest set of dependencies** that can be derived from a set of functional dependencies ``F``.

A closure can answer:
- Is a particular dependency ``X -> Y`` derivable from ``F``?
    - Is ``X -> Y in F+``?
- Are two sets of dependencies ``F`` and ``G`` equivalent?
    - Does ``F+ = G+``?

## Attribute Closure
Given a set of attributes ``X`` and a set of fds ``F``, ``X+`` is the largest set of attributes that can be derived from ``X`` using ``F``. Clearly ``|X+| <= |F|``.

An attribute closure can answer:
- Is ``X -> Y`` derivable from ``F``?
    - Is ``Y \subseteq X+``?
- Are ``F`` and ``G`` equivalent?
    - For each dependency in ``G``, check whether derivable from ``F``.
    - For each dependency in ``F``, check whether derivable from ``G``.
- What are the keys of ``R`` implied by ``F``?
    - Find subsets ``K`` of ``R`` such that ``K+ = R``.

## Minimal Covers
**Minimal cover** ``F_c`` for a set ``F`` of functional dependencies:
- ``F_c+ = F``
- All fds have the form ``X -> A`` where ``A`` is a single attribute.
- It is not possible to make ``F_c`` smaller:
    - Either by deleting an fd.
    - Or by deleting an attribute from an fd.

```py
def get_min_cover(F: Set[FD]) -> Set[FD]:
    return eliminate_redundant_dependencies(
        eliminate_redundant_dependencies(
            get_canonical_form(F)
        )
    )

def get_canonical_form(F: Set[FD]) -> Set[FD]:
    # Split any dependencies that have multiple attributes on the RHS.

def eliminate_redundant_attributes(F: Set[FD]) -> Set[FD]:
    # For all dependencies f:
    #     If f has multiple attributes on the LHS:
    #         Remove each attribute and see if the set with the new dependency has equivalent closure.

def eliminate_redundant_dependencies(F: Set[FD]) -> Set[FD]:
    # For all dependencies f:
    #     Remove f and see if the set with the removed depndency has equivalent closure.
```

