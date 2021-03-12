-- Employee who worked the longest hours
create view LongestHours(employeeName, hoursPweel) as
select e1.givenName || ' ' || e1.familyName, e1.hoursPweek
from Employees e1
inner join (
    select max(hoursPweek) as hoursPweek
    from Employees
) e2 on e1.hoursPweek = e2.hoursPweek 

-- Manager of sales department
create view SalesDepartment(managerName, departmentName) as
select e.familyName as managerName, d.name as departmentName
from Employees e
inner join Departments d on d.manager = e.tfn
where d.name = 'Sales';

-- Hours worked per department per employee
create view EmployeeHoursDepartment(name, hours, department) as
select e.givenName || ' ' || e.familyName as employeeName, 
       e.hoursPweek * wf.percentage / 100 as hours,
       d.name as department
from Employees e
inner join WorksFor wf on wf.employee = e.tfn
inner join Departments d on d.id = wf.department
order by employeeName;