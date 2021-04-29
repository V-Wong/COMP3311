# Functions
## Overview
Defining a function:
```sql
CREATE OR REPLACE funcName(param1, param2, ....) RETURNS rettype AS $$
DECLARE
   -- variable declarations
BEGIN
   -- code for function
END;
$$ LANGUAGE plpgsql;
```

Calling a function:
```sql
select funcName(param1, param2);
-- or 
select * from funcName(param1, param2);
```

## Iterating Over Queries
```sql
for t in (
    select * from Employees
) loop
    totalSalary := totalSalary + t.salary;
end loop;
```

## Returning Tables
```sql
create type EmpInfo as (name text, pay integer);

create function richEmps(_minsal integer) returns setof EmpInfo as $$
declare
   emp record;   info EmpInfo;
begin
   for emp in (
      select * from Employees where salary > _minsal
   ) loop
      info.name := emp.name;
      info.pay := emp.salary;
      return next info;
   end loop;
end; 
$$ language plpgsql;
```

