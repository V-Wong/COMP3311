# Aggregates
## Overview
Aggregates **reduce** a collection of values into a single result.

Examples: ``count(tuples)``, ``sum(numbers)``, ``max(anyOrderedType)``.

## User Defined Aggregate
PostgreSQL syntax:
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

## Example - Calculate Mean
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