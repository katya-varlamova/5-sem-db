create or replace function getAge(birthdate date) returns int as $$
begin
return date_part('year', now()::timestamp) - date_part('year', birthdate::timestamp) - 
cast (date_part('month', now()::timestamp) < date_part('month', birthdate::timestamp) 
 or
 date_part('month', now()::timestamp) = date_part('month', birthdate::timestamp) 
 and date_part('day', now()::timestamp) < date_part('day', birthdate::timestamp) 
	  as int);
end;
$$ LANGUAGE PLPGSQL;
select t.fn, t.age, cast (abs(t.age - t.av) as int) as avgdiff
from
(select c.fullname as fn, getAge(c.birthdate) as age, (select avg(getAge(birthdate)) from cashcollector) as av
from cashcollector c) as t