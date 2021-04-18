# Week 7 Tutorial Problems
1. This constraint cannot be modelled with standard SQL table constraints. Outside of foreign key constraints, standard SQL table constraints cannot enforce conditions on **multiple tables**. 

    ```sql
    CREATE ASSERTION manager_works_in_department
    CHECK (
        NOT EXISTS (
            SELECT *
            FROM Employee e
            JOIN Department d ON d.manager = e.id
            WHERE e.works_in <> d.id
        )
    );
    ```

    Note: PostgreSQL **does not implement database wide assertions** due to the overhead it creates. **Triggers** should be used instead to check validity of inserting rows and also allow updates to make the conditions hold.

2. 
    ```sql
    CREATE ASSERTION employee_manager_salary
    CHECK (
        NOT EXISTS (
            SELECT *
            FROM Employee e
            JOIN Department d ON d.id = e.works_in
            JOIN Employee m ON m.id = d.manager
            WHERE e.salary > m.salary;
        )
    );
    ```

3. 
    ```sql
    CREATE FUNCTION trigger_function() RETURNS trigger
    AS $$
    DECLARE
    BEGIN

    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_name 
    BEFORE INSERT
    ON table
    FOR EACH ROW EXECUTE PROCEDURE trigger_function();


    DROP TRIGGER IF EXISTS trigger_name
    ON table_name;
    ```

4. 
- ``Before``: 
    - ``NEW`` contains "proposed" value of changed tuple. (Does not exist for deletion)
    - Modifying ``NEW`` causes a different value to be placed in DB.

- ``AFTER``:
    - ``NEW`` contains current value of changed tuple. (Does not exist for deletion)
    - ``OLD`` contains previous value of changed tuple. (Does not exist for insertion)
    - Constraint checking has been done for ``NEW``.

    ![trigger diagram](https://cgi.cse.unsw.edu.au/~cs3311/21T1/lectures/triggers/Pics/dbms/trigger-seq.png)

5. 
- ``Insert`` Operation:
    - ``BEFORE`` can be used to check **referential integrity constraints** and add **audit information** to rows. E.g. created_by, create_dt, etc.
    - ``AFTER`` can be used to perform additional database updates to ensure **semantic consistency** of the database, such as enforcing **inter-table dependencies**.

- ``Update`` operation
    - ``BEFORE`` can be used to check **referential integrity constraints** for updated fields and add **audit information** to rows. E.g. updated_by, update_dt, etc.
    - ``AFTER`` can do similar database maintenance as with the ``Insert`` operation.

- Delete Operation:
    - ``BEFORE`` can be used to to check **referential integrity constraints**. E.g. can't delete a tuple because it has tuples in other relations referring to it.
    - ``AFTER`` can do similar database maintenance as with the ``Insert`` operation.

6. a)
    ```sql
    CREATE OR REPLACE FUNCTION r_PK() RETURNS TRIGGER AS $$
    DECLARE
        counter integer;
    BEGIN
        IF new.a IS NULL OR new.b IS NULL THEN
            RAISE EXCEPTION 'Partially specified primary key for R';
        END IF;

        IF TG_OP = 'UPDATE' AND new.a = old.a AND new.b = old.b THEN
            RETURN new;
        END IF;

        SELECT count(*) INTO counter
        FROM R
        WHERE a = new.a AND b = new.b;
        IF counter <> 0 THEN
            RAISE EXCEPTION 'Duplicate primary key for R';
        END IF;

        RETURN new;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER r_PK_check BEFORE 
    INSERT OR UPDATE ON R
    FOR EACH ROW EXECUTE PROCEDURE r_PK();
    ```

    b)
    ```sql
    CREATE OR REPLACE FUNCTION t_FK() RETURNS TRIGGER AS $$
    DECLARE
        counter int;
    BEGIN
        SELECT count(*) INTO counter FROM S WHERE x = new.k;
        IF counter = 0 THEN
            RAISE EXCEPTION 'Invalid foreign key reference from T.k to S.x';
        END IF;

        RETURN new;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER t_FK_check BEFORE
    INSERT OR UPDATE ON T
    FOR EACH ROW EXECUTE PROCEDURE t_FK();
    ```

7. 
    ```sql
    -- Will be activated for every row in an UPDATE statement.
    FOR EACH ROW EXECUTE PROCEDURE trigger_function();

    -- Will be activated only once in an UPDATE statement.
    FOR EACH STATEMENT EXECUTE PROCEDURE trigger_function();
    ```

    a. 
    ```
    update S set y = y + 1 where x = 5;
    ```
    Has no difference for both triggers.

    b.
    ```
    update S set y = y + 1 where x > 5;
    ```
    The first trigger will execute the function on **each of the affected tuples**.

    The second trigger will cause the function to be **executed once**, after all of the affected tuples have been modified, but before the updates have been committed.

    In both cases, if the function fails, none of the updates will take place.

8. The first trigger may cause an update that fires the second trigger which causes an update that fires the first trigger and so on. This creates an **infinite trigger loop**.

9.
    ```sql
    CREATE OR REPLACE FUNCTION emp_audit() RETURNS TRIGGER AS $$
    BEGIN
        IF new.empname IS NULL THEN
            RAISE EXCEPTION 'Employee name must not be null';
        END IF; 

        IF new.salary <= 0 THEN
            RAISE EXCEPTION 'Employee salary must be positive';
        END IF;

        new.last_date := now();
        new.last_user := user();

        RETURN new;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER emp_audit_trigger()
    BEFORE INSERT OR UPDATE ON emp
    FOR EACH ROW EXECUTE PROCEDURE emp_audit();
    ```

10.
    ```sql
    CREATE OR REPLACE FUNCTION course_quota_check() RETURNS TRIGGER AS $$
    DECLARE
        c record;
    BEGIN
        SELECT * INTO c FROM Course WHERE c.code = new.course;

        IF c.numStudes >= c.quota THEN
            RAISE EXCEPTION 'Course quota reached';
        END IF;

        RETURN new;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER course_quota_trigger()
    BEFORE INSERT OR UPDATE ON Enrolment
    FOR EACH ROW EXECUTE PROCEDURE course_quota_check();

    CREATE OR REPLACE FUNCTION ins_course_stu_count() RETURNS TRIGGER AS $$
    BEGIN
        UPDATE Course SET numStudes = numStudes + 1 WHERE code = new.code;
        RETURN new;
    END;
    $$ LANGUAGE plpgsql;

    CREATE OR REPLACE FUNCTION upd_course_stu_count() RETURNS TRIGGER AS $$
    BEGIN
        UPDATE Course SET numStudes = numStudes + 1 WHERE code = new.code;
        UPDATE Course SET numStudes = numStudes - 1 WHERE code = old.code;

        RETURN new;
    END;
    $$ LANGUAGE plpgsql;

    CREATE OR REPLACE FUNCTION del_course_stu_count() RETURNS TRIGGER AS $$
    BEGIN
        UPDATE Course SET numStudes = numStudes - 1 WHERE code = old.code;

        RETURN new;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER ins_stu_trigger()
    BEFORE INSERT OR UPDATE ON Enrolment
    FOR EACH ROW EXECUTE PROCEDURE ins_course_stu_count();

    CREATE TRIGGER upd_stu_trigger()
    BEFORE INSERT OR UPDATE ON Enrolment
    FOR EACH ROW EXECUTE PROCEDURE upd_course_stu_count();

    CREATE TRIGGER del_stu_trigger()
    BEFORE INSERT OR UPDATE ON Enrolment
    FOR EACH ROW EXECUTE PROCEDURE del_course_stu_count();
    ```

11.
    ```sql
    CREATE OR REPLACE FUNCTION new_shipment() RETURNS TRIGGER AS $$
        counter integer;
        newId integer;
    BEGIN
        SELECT count(*) INTO counter FROM Customer WHERE id = new.customer;
        IF counter = 0 THEN
            RAISE EXCEPTION 'Invalid customer id';
        END IF;

        SELECT count(*) INTO counter FROM Editions WHERE isbn = new.isbn;
        IF counter = 0 THEN
            RAISE EXCEPTION 'Invalid isbn';
        END IF;

        IF TG_OP = 'INSERT' THEN
            UPDATE STOCK
            SET numInStock = numInStock - 1,
                numSold = numSold + 1
            WHERE isbn = new.isbn;
        END IF;

        IF TG_OP = 'UPDATE' AND old.isbn <> new.isbn THEN
            UPDATE STOCK
            SET numInStock = numInStock + 1,
                numSold = numSold - 1
            WHERE isbn = old.isbn;

            UPDATE STOCK
            SET numInStock = numInStock - 1,
                numSold = numSold + 1
            WHERE isbn = new.isbn;
        END IF;

        SELECT max(id) + 1 INTO new_id FROM Shipments;

        new.id := new_id;
        new.ship_date := now();

        RETURN new; 
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER new_shipment_trigger()
    BEFORE INSERT OR UPDATE ON Shipments
    FOR EACH ROW EXECUTE PROCEDURE new_shipment();
    ```

12.
    ```sql
    CREATE TABLE Shipments (
        id serial PRIMARY KEY,
        customer INTEGER references Customer(id),
        isbn text REFERENCES Editions(id),
        ship_date timestamp DEFAULT now()
    )
    ```

13.
    ```sql
    CREATE AGGREGATE AggName(BaseType) (
        -- State type
        stype     = ..., 
        -- Initial value
        initcond  = ...,
        -- State transition function
        sfunc     = ...,
        -- Final function (optional)
        finalfunc = ...,
    );
    ```

    Action of aggregate functions:
    ```py
    # sfunc :: (stype, BaseType) -> stype
    # finalfunc :: StateType -> ResultType 

    def aggregate_function(T: list[BaseType]) -> ReturnType:
        state: stype = initcond

        for t in T:
            state = sfunc(state, t)

        return finalfunc(state)
    ``` 

    Note: this is basically the ``reduce`` function in functional programming.

14.
    ```sql
    CREATE TYPE pair AS (
        sum numeric,
        count integer
    );

    CREATE OR REPLACE FUNCTION sum_count(p pair, n numeric) RETURNS pair AS $$
    BEGIN
        IF n IS NOT NULL THEN
            p.sum := p.sum + n;
            p.count := p.count + 1;
        END IF;

        RETURN p;
    END;
    $$ LANGUAGE plpgsql;

    CREATE OR REPLACE FUNCTION calc_mean(p pair) RETURNS numeric AS $$
    BEGIN
        IF p.count = 0 THEN
            RETURN NULL;
        END IF;

        RETURN p.sum / p.count;
    END;
    $$ LANGUAGE plpgsql;

    CREATE AGGREGATE mean(numeric) (
        stype = pair,
        initcond = '(0, 0)',
        sfunc = sum_count,
        finalfunc = calc_mean
    );
    ```

15. 
    ```sql
    select sum(a)::numeric / count(a) from R;

    -- Note: count(a) ignores nulls while count(*) doesn't.
    ```