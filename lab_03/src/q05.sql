create or replace procedure date_to_age(bd date, inout age int)
as $$
declare years int;
declare months int;
declare days int;
begin
    years = date_part('year', now()::timestamp) - date_part('year', bd::timestamp);
    months = cast (date_part('month', now()::timestamp) < date_part('month', bd::timestamp) as int);
    days = cast ((date_part('month', now()::timestamp) = date_part('month', bd::timestamp))
                        and (date_part('day', now()::timestamp) < date_part('day', bd::timestamp)) as int);
    age = years - cast (cast(months as bool) or cast(days as bool) as int);
end;
$$ language plpgsql;

do
$$
declare age int;
declare bd date := '2020-11-09';
begin
call date_to_age(bd, age);
raise notice 'age: %', age;
end
$$ language plpgsql;