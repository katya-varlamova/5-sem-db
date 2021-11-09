create or replace function buildHierarchy() 
returns table(
	DirectorID bigint, 
	DirectorName varchar, 
	WorkerID bigint, 
	WorkerName varchar, 
	lev int) 
as 
$$
begin
return query
with recursive collectorhierarchy (DirectorID, DirectorName, WorkerID, WorkerName, level) as
	(
	select c.director, (select cc.fullname
					   from cashcollector cc 
					   where cc.passport = c.director), c.passport, c.fullname, 0 as level 
	from cashcollector c
	where director is null
	union all
	select c.director, (select cc.fullname
					   from cashcollector cc 
					   where cc.passport = c.director), c.passport, c.fullname, level + 1 
	from cashcollector c join collectorhierarchy ch
	on c.director = ch.WorkerID
	) select * from collectorhierarchy;
end;
$$ 
LANGUAGE PLPGSQL;
select * from buildHierarchy();