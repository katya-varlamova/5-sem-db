create or replace function getAge(bd date)
returns int
as
$$
	import datetime
	d = datetime.date(int(bd[0] + bd[1] + bd[2] + bd[3]), int(bd[-5] + bd[-4]), int(bd[-2] + bd[-1]))
	t = datetime.date.today()
	years = t.year - d.year
	months = t.month - d.month
	days = t.day - d.day
	if months < 0 or (months == 0 and days < 0):
		years -= 1
	return years
$$ language PLPYTHON3U;
select birthdate, getBirthDay( birthdate)
from cashcollector