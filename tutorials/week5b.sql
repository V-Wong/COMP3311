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