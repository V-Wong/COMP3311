# Normalisation and Normal Forms
## Normalisation
**Normalisation** algorithms reduce the amount of redundancy in schemas by **decomposition**.

## Boye Codd Normal Form
### Definition
``R`` is in BCNF w.r.t ``F`` iff:
- For all dependencies ``X -> Y in F+``:
    - Either ``X -> Y`` is trivial.
    - Or ``X`` is a superkey (contains any key).

### Algorithm
```py
def decompose_bcnf(R: Schema, fds: Set[FD]) -> Set[Schema]:
    res = {R}
    while any S in res is not in BCNF:
        violatingFD: FD(X -> Y) = getViolatingFD(S)
        res = (res - S) + (S - Y) + XY

    return res 
```

### Results
A schema in BCNF is **guaranteed** to have:
- No **update anomalies** due to fd-based redundancy.
- **Lossless join decomposition**.

We however may **lose**:
- **Functional dependencies** from the original schema.

## 3rd Normal Form
### Definition
``R`` is in 3NF w.r.t ``F`` iff:
- For all dependencies ``X -> Y in F+``:
    - Either ``X -> Y`` is trivial.
    - Or ``X`` is a superkey (contains any key).
    - Or ``Y`` is a single atttribute from a key (additional condition on top of BCNF).

### Algorithm
```py
def decompose_3nf(R: Schema, fds: Set[FD]) -> Set[Schema]:
    min_cover = get_min_cover(fds)
    res = {}

    for fd: FD(X -> Y) in min_cover:
        if no S in res contains XY:
            res = res + XY

    if no S in res contains a candidate key for R:
        K = any candidate key for R
        res = res + K
```

### Results
A schema in 3NF is **guaranteed** to have:
- **Lossless join decomposition**.
- All the **functional dependencies** of the original schema.

We may **lose**:
- No **update anomalies** due to fd-based redundancy.