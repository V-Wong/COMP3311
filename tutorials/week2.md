# Week 2 Tutorial Problems
2. **Data modelling** is a design process that converts **requirements** into a **data model**. It aims to describe:
    - **information** contained in the database.
    - **relationships** between data items.
    - **constraints** on data.

3. a. A **relationship** in an ER-model is an **association between entities**.
   b. A **relation** in a relational-model is a name and a **set of attributes**. 
   An **instance** of a relation is a set of **tuples** of attribute values.

6. Diagram a) is more **granular** as it stores how much time each researcher worked on a project. In contrast, diagram b) only stores how much time was spent on the project as a whole. We can not infer how much time any given research spent on the project in diagram b).

    In both cases, the thick line between ``WorksOn`` and ``Project`` indicates that every project must have at least one project working on it. But a research doesn't necessarily have to work on any projects.

8. The first design associates each person with a list of their liked cuisines. In contrast, the second design creates a many-to-many relationship between a person and their cuisines they like. The second design allows **more information** to be associated with each cuisine, while the first can **only associate a name** with each cuisine.

16. **Relation model** components:

|Component|Description|
|-|-|
|Attribute|A **name** and an associated **domain**.|
|Domain|Set of allowed values.|
|Relation schema|Describes the **form** of a single relation _R_ with attributes _a_1, ... , a_n_: **R**(_a_1_: _D_1_, ... , _a_n_: _D_2_).|
|Relational schema|Describes the different relations and the relationships between them.|
|Tuple|A list of values which is an element of some relation _R_.|
|Relation|A **name** and a set of **attributes**.|
|Key|A **subset of attributes** of a relation **unique** for each tuple.|
|Foreign key|A **set of attributes** that are the **primary key of one relation** used to **associate with another relation**.|

17. **Duplicate** tuples are not allowed in relations as relations are defined as **sets**.

18. Consider the following simple relational schema:
```
R(a1, a2, a3, a4)
S(b1, b2, b3)
```

Which of the following tuples are not legal in this schema?

```
R(1, a, b, c) 
R(2, a, b, c) 
R(1, x, y, z) # not allowed, primary key must be unique.
R(3, x, NULL, y) 
R(NULL, x, y, z) # not allowed, primary key can not be null.

S(1, 2, x) 
S(1, NULL, y) # not allowed, primary key can not be null.  
S(2, 1, z)
```

19. UNSW database
```
Person(zID, zPass, familyName, givenName, dateOfBirth, countryOfBirth, ...) # zID is primary key

Student(zID, degreeCode, WAM, ...) # zID is both primary key and foreign key.

Staff(zID, office, phone, position, ...) # zID is primary key and foreign key.

Course(cID, code, term, title, UOC, convenor) # cID is primary key.

Room(rID, code, name, building, capacity) # rID is primary key.

Enrolment(course, student, mark, grade) # course and student are foreign keys that together form the primary key.
```

- Person.zID: primary key, 7 digit number.
- Person.zPass: encrypted string.
- Person.familyName: text string, usually < 50 characters.
- Person.givenName: text string, usually < 50 characters.
- Person.dateOfBirth: date, probably between 1900 and today.
- Person.countryOfBirth: foreign key reference to table of countries.
- Student.zID: foreign key, primary key.
- Student.degreeCode: 4? digit number.
- Student.WAM: number between 0 and 100.
- Staff.zID: foreign key, primary key.
- Staff.office: text string, potentially foreign key reference to table of offices.
- Staff.phone: text string, usual validation rules for phone number.
- Staff.position: text string.
- Course.cID: primary key, number.
- Course.code: text string.
- Course.term: number between 1 and 3.
- Course.title: text string.
- Course.UOC: non-negative integer.
- Course.convenor: foreign key reference to Staff.
- Room.rID: primary key, number.
- Room.code: text string.
- Room.name: text string.
- Room.build: text string, potentially foreign key reference to table of buildings.
- Room.capacity: non-negative integer.
- Enrolment.course: foreign key reference to Course.
- Enrolment.student: foreign key reference to Student.
- Enrolment.mark: number between 0 and 100.
- Enrolment.grade: text string in ('F', 'PS', ....).