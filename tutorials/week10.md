# Week 10 Tutorial Problems
## Relational Algebra
1. Relational algebra operators can be **composed** meaning we can take the **output** of one operator **as the input** of another operator.
   This allows us to **combine operators** together to create **complex queries**.

2. The natural join and theta join as given are equivalent.

3. a) ``Proj[speed](PCs)`` as a set:
    |speed|
    |-|
    |700|
    |1500|
    |1000|

    b) ``Proj[speed](PCs)`` as a bag:
    |speed|
    |-|
    |700|
    |1500|
    |1000|
    |1000|
    |700|

    c) Average of set = (700 + 1500 + 1000) / 3 = 1066.66...
    d) Average of bag = (700 + 1500 + 1000 + 1000 + 70) / 5 = 854
    e) Minimum and maximum speeds will be the same for the set and bag representation.

4. a) ``R Div S``:
    |a|
    |-|
    |a1|

    b) ``R Div (Sel[B != b1](S))``:
    |a|
    |-|
    |a1|

    c) ``R Div (Sel[B != b2](S))``:
    |a|
    |-|
    |a1|
    |a2|

    d) ``(R × S) - (Sel[R.C=S.C](R Join[B=B] S)``:
    ``Temp1 = (R x S)``:
    |R.A|R.B|R.C|S.B|S.C|
    |-|-|-|-|-|
    |a1|b1|c1|b1|c1|
    |a1|b1|c1|b2|c2|
    |a1|b2|c2|b1|c1|
    |a1|b2|c2|b2|c2|
    |a2|b1|c1|b1|c1|
    |a2|b1|c1|b2|c2|

    ``Temp2 = (R Join[R.B=S.B] S)``:
    |R.A|R.B|R.C|S.B|S.C|
    |-|-|-|-|-|
    |a1|b1|c1|b1|c1|
    |a2|b1|c1|b1|c1|
    |a1|b2|c2|b2|c2|

    ``Temp3 = Sel[R.C=S.C](R Join[R.B=S.B] S)``:
    |R.A|R.B|R.C|S.B|S.C|
    |-|-|-|-|-|
    |a1|b1|c1|b1|c1|
    |a2|b1|c1|b1|c1|
    |a1|b2|c2|b2|c2|

    ``Temp3 - Temp1``:
    |R.A|R.B|R.C|S.B|S.C|
    |-|-|-|-|-|
    |a1|b1|c1|b2|c2|
    |a1|b2|c2|b1|c1|
    |a2|b1|c2|b2|c2|

5. ``|R1| = N1``, ``|R2| = N2``, ``N1 > N2 > 0``.
    a) ``|R2| <= |R1 U R2| <= |R1| + |R2|``.
    b) ``|R1 n R2| = min(|R1|, |R2|)``.
    c) ``0 <= |R1 - R2| <= |R1|``.
    d) ``|R1 x R2| = |R1| x |R2|``.
    e) ``0 <= |Sel[a=5](R1)| <= |R1|``.
    - Assume that R1 has the attribute ``a``.
    f) ``|Proj[a](R1)| <= |R1|``.
    - Assume that R1 has the attribute ``a``.
    g) ``0 <= |R1 Div R2| <= |R1|``

6. `A` and `B` arbitrary relations. 
    a) ``Sel[cond](A)``: Any subset of ``A`` inherits all of the candidate keys for ``A``.
    b) ``Proj[attrs](A)``: If the projection includes any candidate key ``K`` of ``A``, then ``K`` is candidate key for the projection. Otherwise, the only candidate key is the combination of all projected attributes.
    c) ``A x B``: If ``K`` is a candidate key for `A` and `K'` is a candidate key for `B`, then ``KK'`` is a candidate key for the product.
    d) ``A U B``: If ``A = B``, then the candidate keys are simply those of `A` (or `B`). Otherwise we can't assume anything other than take all attributes.
    e) ``A n B``: Since the intersection is a subset of both sets, candidate keys from both sets are a candidate key for the intersection.
    f) ``A - B``: Since the difference is a subset of `A`, candidate keys from ``A`` is a candidate key for the difference.
    g) ``A Div B``: Since division is a selection followed by a projection on ``A``, similar considerations apply as for projection.

7. 
    a) 
    ```sql
    RedPartIds(part) = Proj[pid](Sel[colour="red"](Parts))
    RedPartSupplierIds(sid) = Proj[supplier](RedPartIds Join Catalog)
    Answer = Proj[sname](RedPartSupplierIds Join Suppliers)
    ```

    b) 
    ```sql
    RedGreenPartIds(part) = Proj[pid](Sel[colour="red" or colour="green"](Parts))
    RedGreenPartSupplierIds(sid) = Proj[supplier](RedGreenPartIds Join Catalog)
    Answer = RedGreenPartSupplierIds
    ```

    c) 
    ```sql
    RedPartIds(part) = Proj[pid](Sel[colour="red"](Parts))
    RedPartSupplierIds(sid) = Proj[supplier](Catalog Join RedPartIds)

    AddressSupplier(sid) = Proj[sid](Sel[address="..."](Suppliers))

    Answer = RedPartSupplierIds U AddressSupplier
    ```

    d) 
    ```sql
    RedPartIds(pid) = Proj[pid](Sel[colour="red"](Parts))
    RedPartSupplierIds(sid) = Proj[supplier](Catalog Join[pid=part] RedPartIds)

    GreenPartIds(pid) = Proj[pid](Sel[colour="green"](Parts))
    GreenPartSupplierIds(sid) = Proj[supplier](Catalog Join[pid=part] GreenPartIds)

    Answer(sid) = RedPartSupplierIds n GreenPartSupplierIds 
    ```

    e)
    ```sql
    AllPartIds(pid) = Proj[pid](Parts)
    SupplierParts(sid, pid) = Proj[supplier, part](Catalog)
    Answer(sid) = SupplierParts Div AllPartIds
    ```

    f) 
    ```sql
    RedPartIds(pid) = Proj[pid](Sel[colour="red"](Parts))
    SupplierParts(sid, pid) = Proj[supplier, part](Catalog)
    Answer(sid) = SupplierParts Div RedPartIds
    ```

    g)
    ```sql
    RedGreenPartIds(pid) = Proj[pid](Sel[colour="red" or colour="red"](Parts))
    SupplierParts(sid, pid) = Proj[supplier, part](Catalog)
    Answer(sid) = SupplierParts Div RedGreenPartIds
    ```

    h) 
    ```sql
    RedPartIds(pid) = Proj[pid](Sel[colour="red"](Parts))
    GreenPartIds(pid) = Proj[pid](Sel[colour="green"](Parts))
    SupplierParts(sid, pid) = Proj[supplier, part](Catalog)
    Answer(sid) = (SupplierParts Div RedPartIds) U (SupplierParts Div GreenPartIds)
    ```

    i)
    ```sql
    C1(sid, pid, cost) = Catalog
    C2(sid, pid, cost) = Catalog
    SupplierPartPairs(C1.sid, C1.pid, C1.cost, C2.sid, C2.pid, C2.cost) 
        = Sel[C1.sid != C2.sid](C1 Join[pid] C2)
    Answer = Proj[C1.pid](SupplierPartPairs)
    ```

    j) 
    ```sql
    C1(sid, pid, cost) = Catalog
    C2(sid, pid, cost) = Catalog
    SupplierPartPairs(C1.sid, C1.pid, C1.cost, C2.sid, C2.pid, C2.cost) 
        = Sel[C1.sid != C2.sid](C1 Join[pid] C2)
    Answer = Proj[C1.sid, C2.sid](Sel[C1.cost > C2.cost](SupplierPartPairs))
    ```

    k)
    ```sql
    -- R1: Parts sold by Yosemite Sham.
    -- R2: R1
    -- R3: All parts that cost less than something else
    -- Answer: All parts - (all parts that cost less than something else)

    R1(sid, pid, cost) = Proj[sid, pid, cost](Sel[name="Yosemite Sham"](Supplier Join[sid=supplier] Catalog))
    R2(sid, pid, cost) = R1
    R3(sid, pid, cost) = Rename[1->sid, 2->pid, 3->cost](Sel[R2.cost < R1.cost](R1 x R2))
    Answer(pid) = Proj[pid](R2 Minus Proj[sid, pid, cost](R3))
    ```

    l)
    ```sql
    CheapParts(pid, sid) = Proj[part, supplier](Sel[cost < 200](Catalog))
    AllSuppliers(sid) = Proj[sid](Suppliers)
    Answer(pid) = Proj[part](CheapParts Div AllSuppliers)
    ```

8. 
    a) Gets the names of suppliers who sell some red part for under 100.
    b) Produces nothing because the relation returned by the inner projection does not have a ``sname`` field.
    c) Gets the name of suppliers who sell sell some red part for under 100 and sells some green part for under 100.
    d) As above but gets the supplier ids instead.
    e) As above but gets both the supplier id and the supplier name. Outermost projection is redundant.

9. 
    a)
    ```sql
    Answer(eid) = Proj[employee](Sel[aircraft="Boeing 747"](Certified))
    ```

    b) 
    ```sql
    CertifiedIds(eid) = Proj[employee](Sel[aircraft="Boeing 747"](Certified))
    Answer(ename) = Proj[ename](Employee Join Certified)
    ```

    c)
    ```sql
    Answer(flno) = Proj[flno](
        Sel[from="New York" and to="Los Angeles"](Flights) 
    )
    ```

    d) No direct relationship between flights and aircraft. Must use distance and cruising range to assign possible aircrafts to a flight.

    ```sql
    FlightAircraft(flno, aid) = Proj[flno, aid](Flights Join[distance <= cruisingRange] Aircraft)
    RichEmployeeIds(eid) = Proj[eid](Sel[salary > 100000](Employee))
    RichEmployeeAircraftIds(aid) = Proj[aircraft](RichEmployeeIds Join[eid=employee] Certified)

    Answer(flno) = Proj[flno](FlightAircraft Join RichEmployeeAircraftIds)
    ```

    e) 
    ```sql
    LongAircraft(aid) = Proj[aid](Sel[cruisingRange > 3000](Aircraft))
    EmployeeLongAircraft(eid) = Proj[employee](
        Certified Join[aircraft=aid] LongAircraft
    )

    BoeingAircraft(aid) = Proj[aid](Sel[name='Boeing 747'](Aircraft))
    EmployeeBoeing(eid) = Proj[employee] (
        Certified Join[aircraft=aid] BoeingAircraft
    )

    Answer(ename) = Proj[ename]((EmployeeLongAircraft - EmployeeBoeing) Join Employee)
    ```

    f) 
    ```sql
    Answer = Sum[salary](Employees)
    ```

    g)
    ```sql
    -- Could have replaced product and select with conditional join.

    E1 = Employees
    E2 = Employees
    LessThanMax(eid, ename, salary) = Proj[E1.eid, E1.ename, E2.salary](Sel[E1.salary < E2.salary](E1 x E2))
    Answer(eid) = Proj[eid](E2 - LessThanMax)
    ```

    h) 

    i)

    j)

    k)

    l)

## Transaction Processing
10. 
    a) **Transaction:** a logical **unit** of work in a DB application. Typically comprises mutliple DBMS operations such as select ... update ... insert ... select ... insert ... etc.
    b) **Serializable schedule:** is a concurrent schedule that produces a final state that is the same as that produced by some serial schedule.
    c) **Conflict-serializable schedule:** if we can transform a schedule:
    - By swapping the orders of non-conflicting operations.
    - Such that the result is a serial schedule.
    d) **View-serializable schedule:** is:
    - Less conservative than conflict serializability.
    - Idea is that across two schdeules:
        - they read the same version of a shared object.
        - they write the same final version of an object.

Recall: A **precedence graph** has a vertex for each transcation ``T1 .. Tn`` and  a directed edge for each pair ``Tj`` and ``Tk`` such that:
    - There is a pair of conflicting operations between ``Tj`` and ``Tk``.
    - ``Tj`` occurs before ``Tk`` operation.

11. ``T2 -> T3 -> T1``. 
    First edge because of ``A`` and second edge because of ``B``.

12. 
    a) ``T2 <-> T3 <- T1``. This is cyclic and so this schedule is not conflict serializable.
    b) Not possible as the the schedule is not conflict-serializable.

13.
    a)
    ```py
    T1: R(X)      W(X)
    T2:      R(X)      W(X)
    ```

    - Is not conflict serializable as we have ``T1 <-> T2`` which is cyclic.
    - Is not view serializable. Compare against the two serial schedules:
        ```py
        # Initial read ok.
        # Final write ok.
        # In original schedule, T2 reads initial value, in this schedule T2 reads an updated value. Not ok.

        T1: R(X) W(X)
        T2:           R(X) W(X)
        ```
        ```py
        # Initial read not ok.

        T1:           R(X) W(X)
        T2: R(X) W(X)
        ```

    b) 
    ```py
    T1: W(X)      R(Y)
    T2:      R(Y)       R(X)
    ```
    - Is conflict serializable as precedence graph is ``T1 -> T2`` which is clearly acylic. In fact, you can just swap the two read operations on ``Y``.
    - Is view serializable as it is conflict serializable.

    c) 
    ```py
    T1: R(X)                R(Y)
    T2:      R(Y)      R(X)
    T3:           W(X)
    ```
    - Is conflict serializable as precedence graph is ``T1 -> T3 -> T2`` which is clearly acyclic. 
    - Is view serializable as it is conflict serializable.

    d) 
    ```py
    T1: R(X) R(Y) W(X)          W(X)
    T2:                R(Y)          R(Y)
    T3:                     W(Y)
    ```
    - Not conflict serializable as precedence graph is ``T1 -> T2 <-> T3`` which is clearly cyclic.
    - Not view serializable. Compare against possible serial schedules (only those with initial read ok):
        ```py
        # In original schedule, the second read in T2 reads Y after being written in T3.

        T1: R(X) R(Y) W(X) W(X)
        T2:                     R(Y) R(Y)
        T3:                               W(Y)
        ```

        ```py
        # In original schdule, the first read in T2 reads Y before being written in T3.
        T1: R(X) R(Y) W(X) W(X)
        T2:                          R(Y) R(Y)
        T3:                     W(Y)
        ```

    e) 
    ```py
    T1: R(X)      W(X)
    T2:      W(X)
    T3:                W(X)
    ```
    - Not conflict serializable as ``T1`` and ``T2`` alone cause a cycle.
    - Compare against serial schedules:
        ```py
        # initial read ok.
        # none of the other transactions reads, so updates are ok.
        # final write ok.
        # is view equivalent to the original schedule.

        T1: R(X) W(X)
        T2:           W(X)
        T3:               W(X)
        ```
