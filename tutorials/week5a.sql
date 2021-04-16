-- Question 1
CREATE FUNCTION sqr(i integer) RETURNS integer AS $$
BEGIN
    RETURN i * i;
END;
$$ LANGUAGE plpgsql;

select sqr(5.0); -- Doesn't work
select(5.0::integer); -- Works
select sqr('5'); -- Works


CREATE FUNCTION sqr(i numeric) RETURNS numeric AS $$
BEGIN
    RETURN i * i;
END;
$$ LANGUAGE plpgsql;

select sqr(5.0); -- Works
select(5.0::integer); -- Works
select sqr('5'); -- Works

-- Question 2
CREATE FUNCTION spread(input text) RETURNS text AS $$
DECLARE
    result text := '';
    i integer;
BEGIN
    FOR i IN 1..length(input) LOOP
        result := result || substring(input, i, 1) || ' ';
    END LOOP;

    return substring(result, 1, length(result) - 1);
END;
$$ LANGUAGE plpgsql;

-- Question 3
CREATE OR REPLACE FUNCTION seq(n integer) RETURNS SETOF integer AS $$
DECLARE
    i integer;
BEGIN
    FOR i IN 1..n LOOP
        -- This does not actually return.
        -- It instead appends rows to the function's result set.
        -- Similarly if we return a query.
        RETURN NEXT i;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Question 4
CREATE OR REPLACE FUNCTION seq(lo int, hi int, inc int) RETURNS SETOF integer AS $$
DECLARE
    i integer;
BEGIN
    IF inc > 0 THEN
        i := lo;
        WHILE i <= hi LOOP
            RETURN NEXT i;
            i := i + inc;
        END LOOP;
    END IF;

    IF inc < 0 THEN
        i := lo; 
        WHILE i >= hi LOOP
            RETURN NEXT i;
            i := i + inc;
        END LOOP;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Question 5
CREATE OR REPLACE FUNCTION seq(n int) RETURNS SETOF INTEGER AS $$
SELECT seq(1, n, 1);
$$ LANGUAGE sql;

-- Question 6
CREATE FUNCTION int_prod(int, int) RETURNS int AS
$$
    SELECT $1 * $2;
$$ LANGUAGE sql;

CREATE AGGREGATE prod(int) (
    sfunc = int_prod,
    stype = int,
    initcond = 1
);

CREATE OR REPLACE FUNCTION fac(n int) RETURNS int AS
$$ 
    SELECT prod(t) FROM seq(n) AS t;
$$ LANGUAGE sql;
