create or replace procedure get_max_level(inout lev int)
as $$
begin
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
                       ) select into lev max(level) from collectorhierarchy;
end;
$$ language plpgsql;

do
$$
    declare lev int;
    begin
        call get_max_level( lev);
        raise notice 'max level: %', lev;
    end
$$ language plpgsql;