
# Entity Relationship Model
## Overview of ER Model
Three major constructs:
- **Attribute**: data item describing a **property** of interest.
- **Entity**: collection of attributes describe **object** of interest.
- **Relationship**: **association** between entities.

## Example ER Diagram
![](https://cgi.cse.unsw.edu.au/~cs3311/21T1/lectures/er-model/Pics/er-rel/er1.png)

|Shape|Meaning|
|-|-|
|Oval|Attribute|
|Rectangle|Entity|
|Diamond|Relationship|

- Underlined attributes are **keys** and **uniquely identify** the entity.
    - Branch number uniquely identifies a branch.

- An arrow indicates an **up to one** relationship.
    - An account is held at only one branch.

- Thickened lines indicates the relationship **must exist**.
    - A customer must own an account (otherwise they are not a customer).

## Entity Sets
Entity sets can be viewed as either:
- A set of entities with the **same set of attributes**.
- An **abstract description** of a class of entities.

**Key (superkey)** any set of attributes whose set of values are **distinct over the entity set**.
- Can be **natural** (e.g. name + address + birthday) or **artificial** (UNSW ZID).

**Candidate key**: minimal superkey (no strict subset is a key).

**Primary key**: candidate key chosen by DB designer.

## Relationship Sets
**Relationship**: association among several entities.
- Customer(100) is the owner of Account(123).

**Relationship set**: collection of relationships of the same type.

**Degree**: # entities involved in relationship (>= 2 in ER model).

**Cardinality**: # associated entities on each side of relationship. Can be one of the following:
- One-to-one.
- One-to-many.
- Many-to-many.

**Participation**: must every entity be in the relationship?
- A loan must be held by a customer.
- A customer doesn't necessarily need to hold a loan.

## Subclasses and Inheritance
A **subclass** of an entity set _A_ is a set of entities:
- with all attributes of _A_, plus (usually) its own attributes.
- that is involved in all of A's relationships, plus its own.

Types of subclasses:
- **Overlapping** or **Disjoint** (can an entity be in multiple subclasses?)
- **Total** or **Partial** (does every entity have to also be in a subclass?).

### Another Example ER Diagram
![](https://cgi.cse.unsw.edu.au/~cs3311/21T1/lectures/er-model/Pics/er-rel/large-ER.png)
