alter table cashcollector drop column age;
create or replace procedure updateAge()
as
$$
	query = "alter table cashcollector add column age int; update cashcollector set age = getAge(birthdate)"
	plpy.execute(query)
$$ language PLPYTHON3U;

do
$$
begin
call updateAge();
end
$$ language plpgsql;