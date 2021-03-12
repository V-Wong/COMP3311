-- Updated schema to enforce constraints

create table Employees (
	tfn         char(11) primary key,
	givenName   varchar(30) not null,
	familyName  varchar(30),
	hoursPweek  float,
    constraint properTfn check (tfn ~* '^\d\d\d-\d\d\d-\d\d\d$'),
    constraint validHours check (hoursPweek >= 0 and hoursPweek <= 7 * 24)
);

create table Departments (
	id          char(3) primary key,
	name        varchar(100) unique,
	manager     char(11) references Employees deferrable,
    constraint validId check (id ~* '\d\d\d')
);

create table DeptMissions (
	department  char(3) references Departments,
	keyword     varchar(20),
    primary key(department, keyword)
);

create table WorksFor (
	employee    char(11) references Employees,
	department  char(3) references Departments,
	percentage  float,
    constraint validPercentage check (percentage > 0 and percentage <= 100),
    primary key(employee, department)
);