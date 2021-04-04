# Week 4 Tutorial Problem
1. Order of table declarations matter because a foreign key must reference a table that already exists.
2. 
    ```sql
    update Employees
    set salary = salary * 0.8
    where age < 25;
    ```

3. 
    ```sql
    update Employees e
    set salary = salary * 1.1
    where eid in (
        select eid
        from Departments d, WorksIn w
        where d.name = 'Sales' and d.did = w.did
    );
    ```

4. 
    ```sql
    create table Departments (
      did     integer primary key,
      dname   text,
      budget  real,
      manager integer not null references Employees(eid)
    );
    ```

5. 
    ```sql
    create table Employees (
      eid     integer primary key,
      ename   text,
      age     integer,
      salary  real check (salary >= 15000),
      primary key (eid)
    );
    ```

6. 
    ```sql
    create table WorksIn (
      eid     integer references Employees(eid),
      did     integer references Departments(did),
      percent real,
      primary key (eid,did),
      constraint MaxFullTimeCheck check (
        (select sum(percent) from WorksIn wi where wi.eid = eid) <= 1
      )
    );
    ```

    Note: ``select`` statements are allowed in the SQL standard, but most DBMS don't allow this.

7. 
    ```sql
    create table WorksIn (
      eid     integer references Employees(eid),
      did     integer references Departments(did),
      percent real,
      primary key (eid,did),
      constraint MaxFullTimeCheck check (
        (select sum(percent) from WorksIn wi where wi.eid = eid) <= 1
      ),
      constraint ManagerFullTimeCheck check (
        eid <> (select manager from Departments d where d.did = did) 
        or percent = 1
      )
    );

    OR alternatively:

    create table Departments (
      did     integer primary key,
      dname   text,
      budget  real,
      manager integer references Employees(eid)

    constraint ManagerFullTimeCheck check (
        (select percent from WorksIn wi where wi.did = did) = 1
      )
    );
    ```

8. 
    ```sql
    create table WorksIn (
        eid     integer,
        did     integer,
        percent real,
        primary key (eid,did),
        foreign key (eid) references Employees(eid) on delete cascade,
        foreign key (did) references Departments(did)
    );
    ```

    Note: the default foreign key setting is ``on delete restrict`` which prevents deletions of parent rows that have child rows that reference it. ``on delete cascade`` will delete the child rows when a parent row is deleted.

9. Remove the ``not null`` constraint from question 4.

10. When deleting from ``Departments``, we have two options for ``WorksIn `` to enforce referential integrity:
    - ``on delete cascade``: delete all rows that reference the deleted department.
    - ``on delete restrict``: if any rows reference the department, reject the delete.
    - ``on delete set null``: if any rows reference the department, the ``did`` will be set to ``null``.

11. 
    - ``on delete cascade``:
        - All rows that involve ``did = 2`` will be deleted in the third table.
    - ``on delete restrict``:
        - Delete will be rejected.
    - ``on delete set null``:
        - All rows that involve ``did = 2`` will set ``did`` to ``null`` in the third table.

12. 
    ```sql
    select sname
    from Suppliers s
    where s.sid in (
        select sid
        from Catalog c
        join Parts p on p.pid = c.pid
        where p.colour = 'Red'
    );

    OR

    select distinct sname
    from Suppliers s
    join Catalog c on c.sid = s.sid
    join Parts p on p.pid = c.pid
    where p.colour = 'Red'
    ```

13. 
    ```sql
    select distinct s.sid
    from Suppliers s
    join Catalog c on c.sid = s.sid
    join Parts p on p.pid = c.pid
    where p.colour = 'Red' or p.colour = 'Green'
    ```

14.
    ```sql
    (
        select sid
        from Suppliers s
        where s.address = '221 Packer Street'
    )
    union
    (
        select s.sid
        from Suppliers s
        join Catalog c on c.sid = s.sid
        join Parts p on p.pid = c.pid
        where p.colour = 'Red'
    )
    ```

    Note: ``union`` eliminates duplicate rows. Use ``union all`` to keep duplicates.

15. 
    ```sql
    (
        select s.sid
        from Suppliers s
        join Catalog c on c.sid = s.sid
        where p.colour = 'Red'
    )
    intersect
    (
        select s.sid
        from Suppliers s
        join Catalog c on c.sid = s.sid
        where p.colour = 'Green'
    )
    ```

16. 
    ```sql
    select sid
    from Suppliers
    where not exists (
        (select distinct pid from Parts)
        except
        (select distinct pid from Catalog join Supplier s on s.sid = sid)
    );

    OR

    select distinct sid
    from Catalog
    group by sid
    having count(pid) = (select count(distinct pid) from Parts);
    ```

17. 
    ```sql
    select sid
    from Suppliers
    where not exists (
        (select distinct pid from Parts where colour = 'Red')
        except
        (select distinct pid from Catalog join Supplier s on s.sid = sid)
    );
    ```

18. 
    ```sql
    select sid
    from Suppliers
    where not exists (
        (select distinct pid from Parts where colour = 'Red' or colour = 'Green')
        except
        (select distinct pid from Catalog join Supplier s on s.sid = sid)
    );
    ```

19. 
    ```sql
    (
        select sid
        from Suppliers
        where not exists (
            (select distinct pid from Parts where colour = 'Red')
            except
            (select distinct pid from Catalog join Supplier s on s.sid = sid)
        )
    )
    union
    (
        select sid
        from Suppliers
        where not exists (
            (select distinct pid from Parts where colour = 'Green')
            except
            (select distinct pid from Catalog join Supplier s on s.sid = sid)
        )
    );
    ```

20. 
    ```sql
    select c1.sid, c2.sid
    from Catalog c1
    join Catalog c2 on c1.pid = c2.pid
    where c1.sid <> c2.sid and c1.cost > c2.cost;
    ```

21. 
    ```sql
    select pid
    from Catalog
    group by pid
    having count(sid) >= 2;
    ```

22.
    ```sql
    select c1.pid
    from Catalog c1
    join Supplier s on s.sid = c1.sid
    where s.sname = 'Yosemite Shame'
    and c.cost = (select max(cost) from Catalog c2 where c2.sid = s.sid);
    ```

23.
    ```sql
    select distinct pid
    from Catalog c
    where c.price < 200
    group by c.pid
    having count(*) = (select count(*) from Suppliers);
    ```