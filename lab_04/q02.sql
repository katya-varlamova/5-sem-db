create or replace function getAvgAge()
returns int
as
$$
query = "select getAge(birthdate) as age from cashcollector"
result = plpy.execute(query)
sum = 0
count = 0
for age in result:
	sum += age['age']
	count += 1
r = sum / count
return int(r)
$$ language PLPYTHON3U;
select getAvgAge()