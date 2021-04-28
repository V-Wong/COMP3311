# Relational Algebra Operations
## Operations
Assume expression ``E`` returns the relation ``R(A1, A2,...,An)``, ``r(R)`` and ``s(S)``.
 
|Operation|Notation|Result|Description|
|-|-|-|-|
|Rename|``Rename[S(B1,B2,...,Bn)](E)``|``S(B1,B2,...,Bn)``|**Renames the attributes** of a schema while keeping the same tuples. Note: we'll often use **implict rename** when performing a sequence of operations.|
|Selection|``Sel[C](r)``|``{t : t in r and C(t)}``|Returns a subset of tuples that **satisfy some condition** ``C``.|
|Projection|``Proj[X](r)``|``{t[X] : t in r}``|Returns a set of tuples containing the **subset ``X`` of attributes** in the original relation.|
|Product|``r x s``|``{(t1 : t2) : t1 in r and t2 in s}``|**Cartesian product** that contains all attributes from both `r` and `s`. May rename attributes to avoid ambiguity.|
|Natural Join|``r Join s``|`{(t1[ABC..J] : t2[K..XYZ]) : t1 in r and t2 in s and match}` where ``match = t1[k] = t2[k] and t1[l] = t2[l] and t1[m] = t2[m]``|**Join** on equality of the **common attributes**. The **common attributes only occur once** in the final relation.|
|Theta Join|``r Join[C] s``|`{(t1 : t2) : t1 in r and t2 in s and C(t1 : t2)}`|**Specialised product** containing only pairs that match on supplier condition ``C``.|
|(Left) Outer Join|``r Left Outer Join[C] s``||As with theta join, but **left relations** are **always included**. Non-matching left relations pad out the right attributes with **null**.|
|Divison|``r Div s``||Represents ``for all`` queries. Just look at the image below.|

Also contains the **binary set operations**: union (``r union s``), intersection (``r intersect s``) and difference ``r - s`` which work exactly as expected.

### Division Example
![](https://cgi.cse.unsw.edu.au/~cs3311/21T1/lectures/ra-join-ops/Pics/relalg/division2.png)