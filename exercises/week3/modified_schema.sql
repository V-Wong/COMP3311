-- Modified schema to force n-1 relations between Employees and Department
-- Deferred foreign key checks to prevent circular dependency problems

create table Employees (
	tfn         char(11) primary key,
	givenName   varchar(30) not null,
	familyName  varchar(30),
	hoursPweek  float,
    department  char(3) not null -- Add foreign key constraint at end,
    constraint  properTfn check (tfn ~* '^\d\d\d-\d\d\d-\d\d\d$'),
    constraint  validHours check (hoursPweek >= 0 and hoursPweek <= 7 * 24)
);

create table Departments (
	id          char(3) primary key,
	name        varchar(100) unique,
	manager     char(11) references Employees deferrable initially deferred,
    constraint  validId check (id ~* '\d\d\d')
);

create table DeptMissions (
	department  char(3) references Departments,
	keyword     varchar(20),
    primary     key(department, keyword)
);

-- Must add this to the end due to circular dependency in references.
alter table Employees
add foreign key (department)
references Departments deferrable initially deferred;