alter table cashcollector add university varchar;
alter table cashcollector rename column education to degree;

update cashcollector
set university = degree->'university';

update cashcollector
set degree = degree->'degree';

select * from cashcollector;