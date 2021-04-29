-- Question 7
CREATE OR REPLACE FUNCTION hotelsIn1(_addr text) RETURNS text AS $$
DECLARE
    r record;
    result text := '';
BEGIN
    FOR r IN (
        SELECT name
        FROM bars
        WHERE addr = _addr
    ) LOOP
        result := result || r.name || e'\n';
    END LOOP;

    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Question 8
CREATE OR REPLACE FUNCTION hotelsIn2(_addr text) RETURNS text AS $$
DECLARE
    r record;
    result text := '';
BEGIN
    FOR r IN (
        SELECT name
        FROM bars
        WHERE addr = _addr
    ) LOOP
        result := result || r.name || e'\t';
    END LOOP;

    IF result = '' THEN 
        RETURN 'There are no hotels in ' || _addr;
    ELSE
        RETURN 'Hotels in ' || _addr || ': ' || result;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Question 9
CREATE OR REPLACE FUNCTION happyHourPrice(hotelName text, beerName text, deductPrice numeric) RETURNS text AS $$
DECLARE
    counter integer;
    hotelBeer record;
BEGIN
    -- Use counter to see how many rows returned.
    SELECT count(*) INTO counter FROM bars WHERE name = hotelName;
    IF counter = 0 THEN
        RETURN 'There is no hotel called ' || '''' || hotelName || '''';
    END IF;

    -- Use not exists to see if the query returns any rows.
    IF NOT EXISTS (SELECT * FROM beers WHERE name = beerName) THEN
        RETURN 'There is no beer called ' || '''' || beerName || '''';
    END IF;

    -- Use the found variable to check if rows returned.
    SELECT INTO hotelBeer * FROM sells s WHERE s.bar = hotelName AND s.beer = beerName;
    IF NOT found THEN
        RETURN hotelName || ' does not serve ' || beerName;
    END IF;

    IF deductPrice > hotelBeer.price THEN
        RETURN 'Price reduction is too large; ' || beerName 
                || ' only costs ' || to_char(hotelBeer.price, '$9.99');
    END IF;

    RETURN 'Happy hour price for ' || beerName || ' at ' || hotelName || ' is ' 
                || to_char(hotelBeer.price - deductPrice, '$9.99');
END;
$$ LANGUAGE plpgsql;

-- Question 10
CREATE OR REPLACE FUNCTION hotelsIn3(suburb text) RETURNS SETOF bars AS $$
    SELECT * FROM bars WHERE addr = suburb;
$$ LANGUAGE SQL;

-- Question 11
CREATE OR REPLACE FUNCTION hotelsIn4(suburb text) RETURNS SETOF bars AS $$
DECLARE
    t record;
BEGIN
    FOR t IN (SELECT * FROM bars WHERE addr = suburb) LOOP
        RETURN NEXT t;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Question 12
-- Note: we can overload functions here to provide multiple implementations.
-- a)
CREATE OR REPLACE FUNCTION employeeSalary1(_id integer) RETURNS real AS $$
    SELECT salary FROM Employees WHERE id = _id;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION employeeSalary2(_id integer) RETURNS real AS $$
DECLARE
    foundSalary real := null;
BEGIN
    SELECT salary INTO foundSalary
    FROM Employees
    WHERE id = _id;

    RETURN foundSalary;
END;
$$ LANGUAGE plpgsql;

-- b)
CREATE OR REPLACE FUNCTION branchDetails1(_location text) RETURNS Branches AS $$
    SELECT * FROM Branches WHERE location = _location;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION branchDetails2(_location text) RETURNS Branches AS $$
DECLARE
    foundBranch Branches := null;
BEGIN
    SELECT * INTO foundBranch
    FROM Branches
    WHERE location = _location;

    RETURN foundBranch;
END;
$$ LANGUAGE plpgsql;

-- c)
CREATE OR REPLACE FUNCTION richEmployees1(real) RETURNS SETOF text AS $$
    SELECT name FROM Employees WHERE salary > $1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION richEmployees2(real) RETURNS SETOF text AS $$
DECLARE
    employeeName text;
BEGIN
    FOR employeeName IN (
        SELECT name FROM Employees WHERE salary > $1
    ) LOOP
        RETURN NEXT employeeName;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- d)
CREATE OR REPLACE FUNCTION highlyPaid1(real) RETURNS SETOF Employees AS $$
    SELECT * FROM Employees WHERE salary > $1;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION highlyPaid2(real) RETURNS SETOF Employees AS $$
DECLARE
    e Employees;
BEGIN
    FOR e IN (
        SELECT * FROM Employees WHERE salary > $1
    ) LOOP
        RETURN NEXT e;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Question 13
CREATE OR REPLACE FUNCTION branchReport() RETURNS SETOF text AS $$
DECLARE
    branch Branches;
    customerAccount record;
    curBalance real;
    out text := '';
BEGIN
    FOR branch IN (
        SELECT * FROM Branches
    ) LOOP
        out := 'Branch: ' || branch.location || ', ' || branch.address || e'\n';
        curBalance := 0;

        out := out || 'Customers: ';
        FOR customerAccount IN (
            SELECT c.name, a.balance
            FROM Accounts a
            JOIN Customers c ON c.name = a.holder
            WHERE a.branch = branch.location
        ) LOOP
            curBalance := curBalance + customerAccount.balance;
            out := out || customerAccount.name || ' ';
        END LOOP;

        out := out || e'\n';
        out := out || 'Total deposits: ' || '$' || round(curBalance::numeric, 2) || e'\n';

        RETURN NEXT out;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Question 14
CREATE OR REPLACE FUNCTION unitName(_ouid integer) RETURNS text AS $$
DECLARE
    t record;
BEGIN
    SELECT ou.name as name, ou.longname as longname, ot.name as type INTO t
    FROM OrgUnit ou 
    INNER JOIN OrgUnitType ot ON ot.id = ou.utype 
    WHERE ou.id = _ouid;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No such unit: %', _ouid;
    END;

    IF t.type = 'University' THEN
        RETURN t.name;
    END IF;

    IF t.type = 'Faculty' THEN
        RETURN t.longname;
    END IF;

    IF t.type = 'School' THEN
        RETURN 'School of ' || t.longname;
    END IF;

    IF t.type = 'Department' THEN
        RETURN 'Department of ' || t.longname;
    END IF;

    IF t.type = 'Centre' THEN
        RETURN 'Centre for ' || t.longname;
    END IF;

    IF t.type = 'Institute' THEN
        RETURN 'Institute of ' || t.longname;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;

-- Question 15
CREATE OR REPLACE FUNCTION unitId(partName text) RETURNS integer AS $$
    SELECT min(id)
    FROM OrgUnit
    WHERE upper(longName) LIKE '%' || upper(partName) || '%';
$$ LANGUAGE SQL;

-- Question 16
CREATE OR REPLACE FUNCTION facultyOf(_ouid integer) RETURNS integer AS $$
DECLARE
    t record;
BEGIN
    SELECT ou.id, ot.name as type INTO t
    FROM OrgUnit ou 
    INNER JOIN OrgUnitType ot ON ot.id = ou.utype 
    WHERE ou.id = _ouid;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No such unit: %', _ouid;
    END IF;

    IF t.type = 'University' THEN
        RETURN null;
    END IF;

    IF t.type = 'Faculty' THEN
        RETURN t.id;
    END IF;

    SELECT owner INTO t
    FROM UnitGroups
    WHERE member = _ouid;

    RETURN facultyOf(t.owner);
END;
$$ LANGUAGE PLPGSQL;