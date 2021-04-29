# Week 3 Tutorial Problems.
1. It is useful to first do an ER design and then converting into a relational schema because:
    - It allows the designer to initially concentrate on an **abstract view of data and relationships**.
    - Removes the need to worry about concrete representation details and fine-grained details about constraints.

2. The links are the obvious ones.
    a. Each staff teaches up to one subject.

    |<u>Staff#</u>|SubjCode|Semester|
    |-|-|-|

    |<u>SubjCode</u>|.....|
    |-|-|

    b. Each staff can teach any number of subjects. Each subject can be taught by any number of staff.

    |<u>Staff#</u>|.....|
    |-|-|

    |<u>Staff#|<u>SubjCode</u>|Semester|
    |-|-|-|

    |<u>SubjCode</u>|.....|
    |-|-|

    c. Each teacher can teach up to one subject. Each subject must be taught by one teacher.

    |<u>SubjCode</u>|Staff#|Semester|
    |-|-|-|

    |<u>Staff#</u>|.....|
    |-|-|

3. 
    a. **Entity-relational mapping:**
    P (parent class)
    |<u>id</u>|a|
    |-|-|

    R (subclass, id foreign key to P)
    |<u>id</u>|b|
    |-|-|

    similarly with S and T.

    b. **Object-oriented mapping**:
    P (parent class)
    |<u>id</u>|a|
    |-|-|

    R (subclass, id foreign key to P)
    |<u>id</u>|a|b|
    |-|-|-|

    similarly with S and T.

    c. **Single-table mapping**:
    |<u>id</u>|a|b|c|d|
    |-|-|-|-|-|

4. The ER and OO mappings from above **cannot** represent the **disjoint** constraint. We can modify the single-table mapping approach to contain an extra field to determine the subclass as follows:

    |<u>id</u>|a|b|c|d|subClass|
    |-|-|-|-|-|-|

    However this still doesn't enforce the constraint fully. Values can be placed in a, b, c and d regardless of the subCLass value.

    In SQL, table constraints or global constraints implemented as **triggers** can be used to enforce the disjoint constraint.

5. a. SQL constraints
    ```sql
        create table R (
            id int,
            name string,
            address string,
            d_o_b date,
            primary key (id)
        );

        OR

        create table R (
            id int not null primary key,
            name string,
            address string,
            d_o_b date
        );
    ```

    b.
    ```sql
        create table S (
            name string,
            address string,
            d_o_b date,
            primary key (name, address)
        );
    ```

6. Suitable SQL constraints
    |Attribute|Constraint|
    |-|-|
    |People's name|varchar(30) for each of family and given name.|
    |Addresses|Broken into street, town, state, country. varchar(30) for each|
    |Ages|Store date of birth instead.|
    |Dollar values|float.|
    |Masses of material|float, >= 0.|

7. 
    ```sql
        -- numeric(p, s).
            -- p: total number of digits
            -- s: total number of digits right of decimal point.

        create table CompanyListing(
            name char(4) not null primary key,
            netWorth numeric(6, 2),
            sharePrice numeric(20, 2)
        );
    ```

8. 
    ```sql
        create table Person (
            familyName varchar(30),
            firstName varchar(30),
            initial char(1), -- use ' ' if not applicable
            streetNumber integer,
            streetName varchar(30),
            suburb varchar(30),
            birthDate date,
            primary key (familyName, firstName, initial)
        );
    ```

9. 
    **Lecturer**
    |<u>LecId</u>|FacId|.....|
    |-|-|-|

    **Teaches**
    |<u>LecId</u>|<u>SubjectId</u>|.....|
    |-|-|-|

    **Subject**
    |<u>SubjectId</u>|.....|
    |-|-|

    **Faculty**
    |<u>FacId</u>|.....|
    |-|-|

    **School**
    |<u>SchoolId</u>|FacId|......|
    |-|-|-|-|

10.
    ```sql
        create table Supplier (
            name varchar(30) not null primary key,
            city varchar(30)
        );

        create table Part (
            number integer not null primary key,
            colour varchar(20)
        );

        create table Supply (
            supplierName varchar(30),
            partNumber integer,
            primary key (supplierName, partNumber),
            foreign key (supplierName) references Supplier(name),
            foreign key (partNumber) references Part(number),
        );
    ```

11.
    **Car**
    |<u>regoNumber</u>|model|year|
    |-|-|-|

    **Owns**
    |<u>regoNumber</u>|<u>licenceNumber</u>|
    |-|-|

    **Person**
    |<u>licenceNumber</u>|name|address|
    |-|-|-|

    **Involved**
    |<u>regoNumber</u>|<u>licenceNumber</u>|<u>reportNumber</u>|
    |-|-|-|

    **Accident**
    |<u>reportNumber</u>|location|date|
    |-|-|-|


    ```sql
        create table Car (
            regoNumber integer not null primary key,
            model varchar(30),
            year number
        );

        create table Person (
            licenceNumber integer not null primary key,
            name varchar(60),
            address varchar(60)
        );

        create table Accident (
            reportNumber integer not null primary key,
            location varchar(60),
            date date
        );

        create table Owns (
            regoNumber integer,
            licenceNumber integer,
            primary key (regoNumber, licenceNumber),
            foreign key (regoNumber) references Car(regoNumber),
            foreign key (licenceNumber) references Person(licenceNumber)
        );

        create table Involved (
            regoNumber integer,
            licenceNumber integer,
            reportNumber integer,
            primary key (regoNumber, licenceNumber, reportNumber),
            foreign key (regoNumber) references Car(regoNumber),
            foreign key (licenceNumber) references Person(licenceNumber),
            foreign key (reportNumber) references Accident(reportNumber)
        )
    ```

    These model do not enforce the **total participation** constraints that each car must be owned by a person (potentially more than one) and that each person must own a car (potentially more than one).

    These constraints cannot be expressed in standard SQL and would need to be implemented as **stored trigger procedures**.
