# Functional Dependency
## Definition
A relation instance ``r(R)`` satsifies a **dependency** ``X -> Y`` if
    - For all ``t, u in r, t[X] = u[X] => t[Y] = u[Y]``.

That is, if two tuples in ``r`` agree in their values for the set of attributes ``X``, then they agree in their values for the set of attributes ``Y``.

``Y`` is said to be **functionally dependent** on ``X``.

## Inference Rules
- **Reflexivity:** ``X -> X``.
- **Augmentation:** ``X -> Y => XZ -> YZ``.
- **Transitivity:** ``X -> Y, Y -> Z => X -> Z``.
- **Additivity:** ``X -> Y, X -> Z => X -> YZ``.
    - Note: this is only for the right hand side.
- **Projectivity/Decomposition:** ``X -> YZ => X -> Y, X -> Z``.
- **Pseudotransitvitiy:** ``X -> Y, YZ -> W => XZ -> W``
