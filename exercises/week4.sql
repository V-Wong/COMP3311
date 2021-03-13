-- Q1: how many page accesses on March 2
create or replace view Q1(nacc) as
select count(*) 
from Accesses
where acctime::date = '2005-03-02'::date;


-- Q2: how many times was the MessageBoard search facility used?
create or replace view Q2(nsearches) as
select count(*) as nsearches 
from Accesses
where page like '%webcms/%messageboard%'
and params like '%state=search%';


-- Q3: on which Tuba lab machines were there incomplete sessions?
create or replace view Q3(hostname) as
select distinct(hostname)
from Hosts h
inner join Sessions s on s.host = h.id
where h.hostname like 'tuba%'
and not s.complete;


-- Q4: min,avg,max bytes transferred in page accesses
create or replace view Q4(min, avg, max) as
select min(nbytes)::int, avg(nbytes)::int, max(nbytes)::int
from Accesses;


-- Q5: number of sessions from CSE hosts
create or replace view Q5(nhosts) as
select count(*)
from Hosts h
inner join Sessions s on s.host = h.id
where h.hostname like '%cse.unsw.edu.au';


-- Q6: number of sessions from non-CSE hosts
create or replace view Q6(nhosts) as
select count(*)
from Hosts h
inner join Sessions s on s.host = h.id
where h.hostname is not null and h.hostname not like '%cse.unsw.edu.au';


-- Q7: session id and number of accesses for the longest session?
create or replace view SessionLengths(sessionId, nAccesses) as
select s.id, count(a)
from Accesses a
inner join Sessions s on s.id = a.session
group by s.id;

create or replace view Q7(session, length) as 
select sessionId, nAccesses
from SessionLengths
where nAccesses = (select max(nAccesses) from SessionLengths);


-- Q8: frequency of page accesses
create or replace view Q8(page,freq) as
select page, count(*)
from Accesses
group by page;


-- Q9: frequency of module accesses
create or replace view Q9(module,freq) as
select split_part(page, '/', 1) as module, count(*)
from Accesses
group by module;


-- Q10: "sessions" which have no page accesses
create or replace view Q10(session) as
select s.id from Sessions s
except
select s.id from Sessions s inner join accesses a on a.session = s.id;


-- Q11: hosts which are not the source of any sessions
create or replace view Q11(unused) as
select h.hostname
from Hosts h
where h.hostname is not null
except
select h.hostname
from Hosts h
inner join Sessions s on s.host = h.id;

create or replace view Q11Alternative(unused) as
select h.hostname
from Hosts h
left join Sessions s on s.host = h.id
group by h.hostname
having count(s.id) = 0;