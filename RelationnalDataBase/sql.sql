select ci.Name from world25.city ci inner join world25.country co on ci.CountryCode = co.Code where co.Name = 'Japan';
select co.Name from world25.country co inner join world25.city ci on co.Code = ci.CountryCode where ci.Name = 'Kingston';
select ci.Name, ci.Population from world25.city ci inner join world25.country co on ci.CountryCode = co.Code where co.Continent = 'Asia' and ci.Population > 5000000 order by ci.Population desc;


select count(*) as nombre_pays_monde from world25.country;
select sum(GNP) as total_gnp_monde from world25.country;
select name, sum(Population) as nombre_population_by_country from world25.country group by Name order by nombre_population_by_country desc;
select sum(ci.Population) as total_population_villes_africaines from world25.city ci inner join world25.country co on ci.CountryCode = co.Code where co.Continent='Africa'; 
select name, Population from world25.country where Population > (select avg(Population) from world25.country) order by Population desc;
select c1.Name, c1.Region, c1.SurfaceArea from world25.country c1 where c1.SurfaceArea = (select max(c2.SurfaceArea) from world25.country c2 where c2.Region = c1.Region);

update world25.country set HeadOfState = 'Emmanuel Macron' where Name='France';
select HeadOfState from world25.country where Name='France';

update world25.country set Population = Population * 1.10 where Continent = 'Europe';
select Population from world25.country where Continent='Europe';

delete from world25.city where Name = 'Paris';
select * from world25.citi where Name = 'Paris';

delete ci from world25.city ci inner join world25.country co on ci.CountryCode = co.Code where co.Continent = 'Africa';
select * from world25.city ci inner join world25.country co on ci.CountryCode = co.Code  where co.Continent = 'Africa';