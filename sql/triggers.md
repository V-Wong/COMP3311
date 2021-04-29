# Triggers
## Overview
Triggers are activated in response to **database events** (e.g. updates).

## Semantics
If activated ``BEFORE``:
- ``NEW`` contains **proposed value** of changed tuple.
- Modifying ``NEW`` causes a **different value** to be placed in DB.
- Uses:
    - Enforce complex **referential integrity** constraints.
    - **Add information** such as timestamps to the new tuple.

If activated ``AFTER``:
- ``NEW`` contains **current value** of changed tuple.
- ``OLD`` contains **previous value** of changed tuple.
- **Constraint-checking** has been done for ``NEW``.
- Uses:
    - Perform additional database updates on **different tuples** to maintain **semantic consistency**.

``OLD`` does not exist for insertion and ``NEW`` does not exist for deletion.

Failures at any point for any trigger causes changs to be rolled back.

## Syntax
```sql
create trigger triggerName before insert or update
on TableName
for each row execute procedure procedureName();

create function procedureName() returns trigger as $$
declare
    -- variable declarations
begin
    -- code for function

    return new;
end;
$$ language plpgsql;
```