-- COMP3311 18s1 Prac 05 Exercises

-- Q1. What beers are made by Toohey's?

create or replace view Q1 as
select Beers.name
from Beers
join Brewers on Brewers.id = Beers.brewer;

-- Q2. Show beers with headings "Beer", "Brewer".

create or replace view Q2 as
select Beers.name, Brewers.name
from Beers
join Brewers on Brewers.id = Beers.brewer;

-- Q3. Find the brewers whose beers John Likes.

create or replace view Q3 as
select distinct Brewers.name
from Brewers
join Beers on Beers.brewer = Brewers.id
join Likes on Likes.beer = Beers.id
join Drinkers on Drinkers.id = Likes.drinker
where Drinkers.name = 'John';

-- Q4. How many different beers are there?

create or replace view Q4 as
select count(*)
from Beers;

-- Q5. How many different brewers are there?

create or replace view Q5 as
select count(*)
from Brewers;

-- Q6. Find pairs of beers by the same manufacturer
--     (but no pairs like (a,b) and (b,a), and no (a,a))

create or replace view Q6 as
select b1.name, b2.name
from Beers b1
join Beers b2 on b1.brewer = b2.brewer
where b1.name < b2.name
order by b1.name;

-- Q7. How many beers does each brewer make?

create or replace view Q7 as
select br.name, count(*) as nBeers
from Brewers br
join Beers be on be.brewer = br.id
group by br.id
order by br.name;

-- Q8. Which brewer makes the most Beers?

create or replace view Q8 as
select name
from Q7
where nBeers = (select max(nBeers) from q7);

-- Q9. Beers that are the only one by their brewer.

create or replace view Q9 as
select name
from Beers
where brewer in (
    select br.id
    from Q7
    join Brewers br on br.name = Q7.name
    where nBeers = 1
);

-- Q10. Beers sold at Bars where John drinks.

create or replace view Q10 as
select distinct b.name
from Beers b
join sells s on s.beer = b.id
join Frequents f on f.bar = s.bar
join Drinkers d on d.id = f.drinker
where d.name = 'John'
order by b.name;

-- Q11. Bars where either Gernot or John drink.

create or replace view DrinksAt as
select b.name as bar, d.name as drinker
from Bars b
join Frequents f on f.bar = b.id
join Drinkers d on d.id = f.drinker;

create or replace view Q11 as
select distinct bar
from DrinksAt
where drinker = 'Gernot' or drinker = 'John'
order by bar;

-- Q12. Bars where both Gernot and John drink.

create or replace view Q12 as
(
    select distinct bar
    from DrinksAt
    where drinker = 'Gernot'
)
intersect
(
    select distinct bar
    from DrinksAt
    where drinker = 'John'
);

-- Q13. Bars where John drinks but Gernot doesn't

create or replace view Q13 as
(
    select distinct bar
    from DrinksAt
    where drinker = 'John'
)
except
(
    select distinct bar
    from DrinksAt
    where drinker = 'Gernot'
);

-- Q14. What is the most expensive beer?

create or replace view Q14 as
select b.name
from Beers b
join Sells s on s.beer = b.id
where s.price = (select max(price) from Sells);

-- Q15. Find Bars that serve New at the same price
--      as the Coogee Bay Hotel charges for VB.

create or replace view BarBeerPrice as
select Bars.name as bar, Beers.name as beer, Sells.price as price
from Sells
join Beers on Beers.id = Sells.beer
join Bars on Bars.id = Sells.bar;

create or replace view Q15 as
select bar
from BarBeerPrice
where beer = 'New'
and price = (
    select price
    from BarBeerPrice
    where bar = 'Coogee Bay Hotel'
    and beer = 'Victoria Bitter'
);

-- Q16. Find the average price of common Beers
--      ("common" = served in more than two hotels).

create or replace view Q16 as
select beer, round(avg(price)::numeric, 2)
from BarBeerPrice
group by beer
having count(bar) >= 2;

-- Q17. Which bar sells 'New' cheapest?

create or replace view Q17 as
select bar
from BarBeerPrice
where beer = 'New'
and price = (select min(price) from BarBeerPrice where beer = 'New');

-- Q18. Which bar is most popular? (Most Drinkers)

create or replace view BarPopularity as
select b.name, count(*) as ndrinkers
from Bars b
left join Frequents f on f.bar = b.id
group by b.name;

create or replace view Q18 as
select name
from BarPopularity
where ndrinkers = (select max(ndrinkers) from BarPopularity);

-- Q19. Which bar is least popular? (May have no Drinkers)

create or replace view Q19 as
select name
from BarPopularity
where ndrinkers = (select min(ndrinkers) from BarPopularity);

-- Q20. Which bar is most expensive? (Highest average price)

create or replace view BarAveragePrice as
select bar, round(avg(price)::numeric, 2) as avgprice
from BarBeerPrice
group by bar;

create or replace view Q20 as
select bar
from BarAveragePrice
where avgprice = (select max(avgprice) from BarAveragePrice);

-- Q21. Which Beers are sold at all Bars?

create or replace view Q21 as
select beer, count(bar)
from BarBeerPrice
group by beer
having count(bar) = (select count(*) from bars);

-- Q22. Price of cheapest beer at each bar?

create or replace view Q22 as
select bar, min(price)
from BarBeerPrice
group by bar;

-- Q23. Name of cheapest beer at each bar?

create or replace view Q23 as
select bar, beer
from BarBeerPrice b1
where price = (
    select min(price)
    from BarBeerPrice b2
    where b2.bar = b1.bar
);


-- Q24. How many Drinkers are in each suburb?

create or replace view Q24 as
select addr, count(*)
from Drinkers
group by addr;

-- Q25. How many Bars in suburbs where Drinkers live?
--      (Must include suburbs with no Bars)

create or replace view Q25 as
select Q24.addr, count(Bars)
from Q24
left join Bars on Bars.addr = Q24.addr
group by Q24.addr;