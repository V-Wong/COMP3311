## Relational Data Modal
### Overview of Relational Data Model
A **relational data model** describes the the world as a collection of inter-connected **relations** (or **tables**).

Relations used to model both **entities and relations**.

Each **relation** (denoted _R_, _S_, _T_, ...) has:
- a **name** (unique within a given database).
- a set of **attributes** (column headings).

Each **attribute** (denoted A, B, ... or a_1, a_2, ...) has:
- a **name** (unique within a given relation).
- an associated **domain** (set of allowed values).

Consider a relation _R_ with attributes a_1, a_2, ... a_n.

**Relation schema**: **R**(a_1: D_1, a_2: D_2, .... a_n: D_n).

**Tuple**: an element of D_1 x D_2 x ... x D_n (list of values).

**Instance**: subset of D_1 x D_2 x ... x D_n (set of tuples).

### Example RDM
A relation: **Account**(branchName, accountNo, balance)

And an instance of this relation:
```
{
    (Sydney, A-101, 500),
    (Coogee, A-215, 700),
    ...
}
```

This can be viewed equivalently with the table:

**Account**
|branchName|accoutnNo|balance|
|-|-|-|
|Sydney|A-101|500|
|Coogee|A-215|700|
