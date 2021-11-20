create type person as
(
	name varchar,
	birthdate date
);
create or replace function getPersons()
returns setof person
as
$$
	arr = []
	result = plpy.execute("select * from cashcollector")
	for i in result:
		arr.append([ i['fullname'], i['birthdate'] ])	
	return tuple(arr)
$$ language plpython3u;

select * from getPersons()