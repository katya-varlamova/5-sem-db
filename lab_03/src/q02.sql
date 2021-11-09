create or replace function deliverers() returns table(collectorname varchar, passport bigint) as 
$$
begin
return query (select c.fullname, c.passport
			  from cashcollector c join requests r on c.passport = r.collectorid
			  where r.service like 'delivery%');
end;
$$ 
LANGUAGE PLPGSQL;
select * from deliverers();