# Week 9 Tutorial Problems
## 1. Functional Dependencies
a) If X is a candidate key for a relation R, then all other keys and sets of keys are functionally dependent on X.

b) Functional dependencies that do not hold:
- A -> C
- B -> A
- B -> C
- C -> B
- C -> A

c) A -> B indicates every A value in R has exactly one corersponding B value, and similarly B -> A tells us that every B value has exactly on corresponding A value. Therefore E and F have a one-to-one correspondence and so the relationship is 1:1.

## 2. More Functional Dependencies
R(A, B, C, D, E, F, G)
F = {A -> B, BC -> F, BD -> EG, AD -> C, D  -> F, BEG -> FA}
a) A<sup>+</sup> = {A, B}

b) 
- A -> B ({A, B, C, E, G})
- BC -> F ({A, B, C, E, F, G})

c)
- BD -> EG ({B, D, E, G})
- BEG -> FA ({A, B, D, E, F, G})
- AD -> C ({A, B, C, D, E, F, G}) 

## 3. Normalisation Forms
R(A, B, C, D, E)
F = {A -> B, BC -> E, ED -> A}

a) Recall: A **candidate key** is any set X such that X<sup>+</sup> = R and there is no strict subset Y of X such that Y<sup>+</sup> = R. 
    
Candidate keys: ACD, CDE, BCD

b) Recall: A relation schema R is in **3NF** w.r.t a set F of functional dependencies iff:
- For all fds X -> Y in F<sup>+</sup>.
    - Either X -> Y is trivial.
    - Or X is a **superkey**.
    - Or Y is a single attribute from a key.

R is in 3NF as all the right hand sides of the dependencies are parts of a key.

c) Recall: A relation schema R is in **BCNF** is a specialisation of 3NF where the last **single key attribute condition is removed**. Important note: a schema in BCNF is not necessarily in 3NF as we may lose some functional dependencies.

R is not in BCNF as none of the left hand sides contain a key.

## 4. More Functional Dependency
R(A, B, C, D)

a) {C -> D, C -> A, B -> C}
- i) Candidate keys: B.
- ii) R is not in BCNF. In C -> A, C does not contain a key.
- iii) R is not in 3NF. In C -> A, C does not contain a key and A is not part of a key.

b) {B -> C, D -> A}
- i) Candidate keys: BD.
- ii) R is not in BCNF. In B -> C, B is not a superkey.
- iii) R is not in 3NF. In B -> C, B is not a superkey and C is not part of a key.

c) {ABC -> D, D -> A}
- i) Candidate keys: ABC, DBC.
- ii) R is not in BCNF. In D -> A, D is not a superkey.
- iii) R is in 3NF. ABC -> D has ABC as a superkey and D -> A has A as part of a key.

e) {A -> B, BC -> D, A -> C}
- i) Candidate keys: A.
- ii) R is not in BCNF. In BC -> D, BC is not a superkey.
- iii) R is not in BCND. In BC -> D, BC is not a superkey and D is not part of a key.

f) {AB -> C, AB -> D, C -> A, D -> B}
- i) Candidate keys: AB, CD.
- ii) R is not in BCNF. In C -> A, C is not a superkey.
- iii) R is in 3NF. All of the right hand sides are single attributes of a key.

g) A -> BCD
- i) Candidate keys: A.
- ii) R is in BCNF. Clearly A is a superkey in A -> BCD.
- iii) R is in 3NF, read above.

## 5. Team-Players-Fans Schema
- Team: name -> captain.
- Player: name -> teamPlayedFor.
- Fan: name -> address.

The first three tables have all attributes depend on name only. They are hence in BCNF.

The remaining tables only have trivial functional dependecies.

The whole schema is hence in BCNF.

## 6. Trucks-Shipments-Stores Schema
- Warehouse: warehouseNo -> address.
- Trip: tripNo -> date, truck.
- Truck: truckNo -> maxVol, maxWt.
- Shipment: shipmentNo -> volume, weight, trip, store.
- Store: storeNo -> storeName, address.

For each table, the attributes depend only on the (super)key. The schema is hence in BCNF. 

## 7. Decomposing Relations
```py
def decompose_bcnf(R: Schema, fds: Set[FD]) -> Set[Schema]:
    res = {R}
    while any S in res is not in BCNF:
        violatingFD: FD(X -> Y) = getViolatingFD(S)
        res = (res - S) + (S - Y) + XY

    return res 
```

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

a) {C -> D, C -> A, B -> C}
Candidate Keys for R: B.
- 3NF:
    - Minimal cover: {C -> D, C -> A, B -> C}.
    - X = CD, Y = CA, Z = BC.
    - X, Y and Z are from the decomposition. All fds for each relation have a superkey on the LHS.
- BCNF:
    - ABCD => ABD BC.
    - (We could have also used the above 3NF).

b) {B -> C, D -> A}
Candidate Keys for R: BD.
- 3NF:
    - Minimal cover: {B -> C, D -> A}.
    - X = BC, Y = DA, Z = BD.
    - The first two relations are from the the decomposition, while the last relation is a linking relation with a fd containing the candidate key of R.
- BCNF:
    - ABCD => ACD BC => AD BC CD.

c) {ABC -> D, D -> A}
Candidate Keys for R: ABC, BCD.
- 3NF:
    - Minimal Cover: {ABC -> D, D -> A}.
    - X = ABCD.
    - Since X already contains DA, we don't need a new relation for it.
- BCNF:
    - ABCD => BCD DA.
    - The D -> A is the violating fd here. Note that this BCNF decomposition loses the other dependency.

d) {A -> B, BC -> D, A -> C}
Candidate Keys for R: A.
- 3NF:
    - Minimal Cover: {A -> B, BC -> D, A -> C}.
    - X = AB, Y = BCD, Z = AC.
    - X and Y both contain a candidate key, so we are done.
- BCNF:
    - ABCD => ABC BCD.

e) {AB -> C, AB -> D, C -> A, D -> B}
Candidate Keys for R: AB, CD.
- 3NF:
    - Minimal Cover: {AB -> C, AB -> D, C -> A, D -> B}.
    - X = ABCD.
    - The first two fd contain a superkey on the LHS. The last two fd contain a single attribute of a key on the RHS.
- BCNF:
    - ABCD => BCD CA => CD DB CA.

f) {A -> BCD}
Candidate Keys for R: A.
- 3NF:
    - Minimal Cover: {A -> BCD}.
    - X = ABCD.
    - Already in 3NF.
- BCNF:
    - Also already in BCNF.

## 8. Banking System
R(accountNo, branchNo, tfn, kind, balance, city, name)

a) Suitable functional dependencies:
- accountNo -> branchNo, kind, balance.
- branchNo -> city.
- tfn -> name.

b) 3NF decomposition:
- Minimal cover is equivalent to above.
- Candidate Keys: accountNo, tfn.
- Account(accountNo, branchNo, kind, balance).
- Branch(branchNo, city).
- Customer(tfn, name).
- CustomerAccount(tfn, accountNo).

c) The schema is also in BCNF.

## 9. Project System
R(pNum, pName, eNum, eName, jobClass, payRate, hours)

a) Suitable functional dependencies.
- pNum -> pName.
- eNum -> eName.
- jobClass -> payRate.
- pNum, eNum -> jobClass, payRate, hours.

b) BCNF Decomposition:
- Candidate Keys: {pNum, eNum}
- A(pNum, pName, eNum, eName, jobClass, payRate, hours)
    => A(pNum, eNum, eName, jobClass, payRate, hours) + B(pNum, pName)
    => A(pNum, eNum, jobClass, payRate, hours) + B(pNum, pName) + C(eNum, eName)
    => A(pNum, eNum, jobClass, hours) + B(pNum, pName) + C(eNum, eName) + D(jobClass, payRate).
    => ProjectEmployee(pNum, eNum, jobClass, hours) + Project(pNum, pName) + Employee(eNum, eName) + Job(jobClass, payRate).

c) The above schema is not in 3NF as we have lost the dependency pNum, eNum -> payRate.

## 10. Real Estate System
Dependencies:
- propertyNum -> address.
- staffNum -> name, carReg. (Assuming staff only use the same car).
- propertyNum, when -> staffNum, notes. (One staff carries out each property visit).

## 11. Company System
Dependencies:
- contract -> abn, hotel.
- abn -> hotel.
- tfn -> name.
- contract, tfn -> hrs.

## 12. More Functional Dependencies
Dependencies:
- A -> BCD. Since A has a different value in every tuple.

## 13. Minimal Cover
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

F = {B -> A, D -> A, AB -> D}

We can prove that the A in AB -> D is redundant:
- B -> D
    => AB -> AD
    => AB -> A and AB -> D.

F' = {B -> A, D -> A, B -> D}

B -> A is unnecessary as it is implied by transitivity.

min(C) = {D -> A, B -> D}.

## 14. Real Estate Inspection BCNF
Dependencies:
- propertyNum -> address.
- staffNum -> name, carReg. (Assuming staff only use the same car).
- propertyNum, when -> staffNum, notes. (One staff carries out each property visit).

Candidate keys: {propertyNum, when}.

R(pNum, when, address, notes, sNum, name, carReg)
- => A(pNum, when, notes, sNum, name, carReg) + B(pNum, address).
  => A(pNum, when, notes, sNum) + B(pNum, address) + C(sNum, name, carReg).
  => RentalVisit(pNum, when, notes, sNum) + Property(pNum, address) + Staff(sNum, name, carReg).

## 15. BCNF Decomposition
R = ABCDEFGH
F = {ABH -> C, A -> DE, BGH -> F, F-> ADH, BH -> GE}.
Candidate Keys for R: BH. 

ABCDEFGH => ABCFGH ADE.
- ADE is in BCNF.

Decomposing ABCFGH:
- F = {ABH -> C, BGH -> F, F -> AH, BH -> G} (Note that certain attributes on the RHS have been lost). This is allowed as we could have decomposed the dependency into separate dependencies. Losing attributes on the LHS is not allowed, we remove the whole dependency in those cases.
- Candidate Keys: BH.

ABCDEFGH => BCFG FAH ADE.
- BCFG loses all dependencies and FAH and ADE are in BCNF.

We are hence done and obtain: BCFG FAH ADE.

## 16. 3NF Decomposition
R(P, W, A, N, S, M, C)
F = {P -> A, S -> MC, PW -> SN} = {P -> A, S -> M, S -> C, PW -> S, PW -> N}.

Candidate key: PW.

Calculating minimal cover:
- Already a minimal cover.

R_1 = PA, R_2 = SMC, R_3 = PWSN.

R_3 contains the candidate key, so we are done.

## 17. More 3NF Decomposition
R = ABCDEFGH
F_C = {BH -> C, A -> D, C -> E, F -> A, E -> F, BH -> E} = {BH -> CE, A -> D, C -> E, F -> A, E -> F}

Candidate key: BHG. (G must be added as it depends on nothing).

R_1 = BHCE, R_2 = AD, R_3 = CE, R_4 = FA, R_5 = EF, R_6 = BGH.
