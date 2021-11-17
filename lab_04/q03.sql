create or replace function getCollectorTableWithAge()
returns table (id bigint, name varchar, age int)
as
$$
	query = "select c.passport as id, c.fullname as name, getAge(c.birthdate) as age from cashcollector c;"
	result = plpy.execute(query)
	return result
$$ language plpython3u;

select * 
from getCollectorTableWithAge()