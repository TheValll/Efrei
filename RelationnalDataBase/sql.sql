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

delete from world25.city where CountryCode = 'FRA';
commit;
delete from world25.city where CountryCode = 'DEU';
commit;

set autocommit =0;
select count(*) from world25.city where CountryCode = 'FRA';
select count(*) from world25.city where CountryCode = 'DEU';
rollback;
select count(*) from world25.city where CountryCode = 'FRA';
select count(*) from world25.city where CountryCode = 'DEU';
delete from world25.city where CountryCode = 'FRA';
commit;
select count(*) from world25.city where CountryCode = 'FRA';

delete from world25.city where CountryCode = 'CAN';
savepoint delete_canada;
delete from world25.city where CountryCode = 'CHN';
select count(*) from world25.city where CountryCode = 'CAN';
select count(*) from world25.city where CountryCode = 'CHN';
rollback to savepoint delete_canada;
commit;
select count(*) from world25.city where CountryCode = 'CAN';
select count(*) from world25.city where CountryCode = 'CHN';

select * from world25.city where CountryCode=?;

delimiter //
create procedure update_population(in p_Continent varchar(50), in p_percentage decimal)
begin
	set sql_safe_updates = 0;
    update world25.city ci inner join world25.country co on ci.CountryCode = co.Code set ci.Population = ci.Population * p_percentage / 100 where co.Continent = p_Continent;
    update world25.country set Population = Population * p_percentage / 100  where Continent = p_Continent;
    set sql_safe_updates = 1;
end //
delimiter ;
