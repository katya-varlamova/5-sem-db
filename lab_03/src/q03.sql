create or replace function deliverers() returns table(collectorname varchar, passport bigint) as 
$$
begin
create temp table tmp (
	collectorname varchar(30),
	passport bigint
);
insert into tmp
select c.fullname, c.passport
from cashcollector c join requests r on c.passport = r.collectorid
where r.service like 'delivery%';
return query select * from tmp;
end;
$$ 
LANGUAGE PLPGSQL;
select * from deliverers();