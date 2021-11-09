create or replace procedure print_indexes(dbname varchar, tblname varchar)
as $$
    declare dbn varchar;
    declare cur cursor for
                select * from pg_indexes
                where tablename = tblname;
    declare rec record;
    begin
        select into dbn max(table_catalog) from information_schema.tables;
        if dbn != dbname
        then
            raise notice 'cross-database references are not implemented!';
        else
			open cur;
            fetch next from cur into rec;
            while(found) loop
                    raise notice '%', rec;
                    fetch next from cur into rec;
                end loop;
			close cur;

        end if;
    end
$$ language plpgsql;

do
$$
    begin
        call print_indexes( 'postgres', 'objects');
    end
$$ language plpgsql;