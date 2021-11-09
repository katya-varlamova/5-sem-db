create or replace procedure print_major_collectors()
as $$
declare
    rec record;
    cur cursor for
    select c.fullname as cn, r.address as address
    from cashcollector c join requests r on r.collectorid = c.passport
    where c.rank = 'major';

begin
    open cur;
    fetch next from cur into rec;
    while (found)
    loop
        raise notice 'collector: %, address: %', rec.cn, rec.address;
        fetch next from cur into rec;
    end loop;
    close cur;
end
$$ language plpgsql;

do
$$
    begin
        call print_major_collectors( );
    end
$$ language plpgsql;