-- все пары фио инкассаторов одного ранга, отсортированные по фио
select c1.fullname, c2.fullname
from cashcollector as c1 inner join cashcollector as c2 on c1.rank = c2.rank
where c2.passport > c1.passport
order by c1.fullname 

-- фио и даты рождения инкассаторов, родившихся в промежутке [1983, 1993) годов
select fullname, birthdate
from cashcollector 
where birthdate between '1983-01-01' and '1993-01-01'
order by birthdate

-- фио и дата последнего заезда инкассатора, который выполнял услугу инкассации
select fullname, max(r.requestDate) as lastRequest
from cashcollector as c join requests as r on c.passport = r.collectorID
where r.service like 'enc%'
group by c.fullname

-- адреса всех точек, на которые выезжали инкассаторы, родившееся в промежутке [1983, 1993) годов
select distinct o.address
from objects as o join requests as r on o.id = r.objectID join cashcollector as c on c.passport = r.collectorID 
where c.passport in (select c.passport
				from cashcollector c
				where c.birthdate between '1983-01-01' and '1993-01-01')

-- вся информация об инкассаторах, которые выполнили хотя бы одну заявку после февраля 2020
select *
from cashcollector cc
where exists (select 
			 	from cashcollector c join requests r on c.passport = r.collectorID
			 	where cc.passport = c.passport and r.requestDate > '2020-02-01')

-- фио всех инкассаторов, которые выполнили больше заявок, чем все инкассаторы из регионов, номера которых < 56
select c.fullname
from cashcollector c 
where c.requests > all(select cc.requests
					  	from cashcollector cc
					  	where cc.region < 56)

-- паспорт, фио и количество заявок, выполненных каждым инкассатором
select c.passport, c.fullname, test.cnt
from cashcollector c left join (select count(r.id) as cnt, passport, fullname
								from cashcollector c join requests r on c.passport = r.collectorID 
								group by passport) test on test.passport=c.passport

-- паспорт, фио и количество заявок, выполненных каждым инкассатором
select c.passport, 
		(select count(cc.passport)
		from cashcollector cc join requests r on cc.passport = r.collectorID
		where c.passport = cc.passport),
		c.fullname
from cashcollector c

--поменять название должности с 'major' на 'director' и 'ordinary' на 'typical' для каждого инкассатора
select c.passport,
		(case c.rank
		when 'major' then 'director'
		when 'ordinary' then 'typical'
		else 'unexpected' 
		end) as newrank,
		c.rank,
		c.fullname
from cashcollector c

-- добавить столбец с категорией возраста
select c.passport,
		(case
		when c.birthdate > '1995-01-01' then 'young'
		when c.birthdate > '1985-01-01' then 'middle'
		when c.birthdate < '1985-01-01' then 'old'
		end) as agecategory,
		c.fullname,
        c.birthDate
from cashcollector c

--создать новую таблицу заявок, в которой указан id заявки, имя инкассатора и адрес объекта
select r.id, c.fullname, o.address
into newRequests
from requests r join cashcollector c on c.passport = r.collectorid
				join objects o on r.objectid = o.id;

-- паспорт, фио и количество заявок, выполненных каждым инкассатором
select c.passport, c.fullname, test.cnt
from cashcollector c left join (select r.collectorID as id, count(r.id) as cnt
								from requests r
								group by r.collectorID) test on test.id=c.passport

-- id объекта и количество раз, которое этот объект был инкассируем инкассатором из региона с номером, большим, чем среднее значение региона
select o.id,
		(select count(obj.id)
		from objects obj join requests r on obj.id = r.objectid join cashcollector c on r.collectorid = c.passport
		where o.id = obj.id and c.region > (select avg(cc.region)
											  	from cashcollector cc))
from objects o

-- паспорт, фио инкассаторов и количество заявок, которые были выполнены
select c.passport, c.fullname, count (r.id)
from cashcollector c join requests r on c.passport = r.collectorid
group by c.passport

-- паспорт, фио инкассаторов и количество заявок (> 2), которые были выполнены
select c.passport, c.fullname, count (r.id)
from cashcollector c join requests r on c.passport = r.collectorid
group by c.passport
having count (r.id) > 2

-- вставка строки
insert into cashcollector (passport, fullname, birthdate, rank, region, requests) 
values ('4521556322','katya varlamova', '2001-08-17', 'major', '02', 10)

--многострочная вставка
insert into cashcollector (passport, fullname, birthdate, rank, region, requests) 
select passport + 1001, fullname, birthdate, rank, region, requests
from cashcollector 
where requests > (select avg(requests)
				 from cashcollector)

--обновление
update cashcollector
set rank = 'experienced'
where birthdate < '1985-01-01'

-- обновление с подзапросом
update cashcollector
set region = (select max(region)
			 from cashcollector)
where birthdate < '1985-01-01'

--delete
delete from requests
where service like 'delivery%'

--delete с подзапросом
delete from requests r
where r.id in (select req.id
			 	from requests req join cashcollector c on req.collectorid = c.passport
			  	where c.birthdate < '1985-01-01')

-- среднее количество заявок с услугой инкассации среди инкассаторов
with cte (passport, requests) as
(select c.passport,
		(select count (requests.id)
		 from requests join cashcollector on cashcollector.passport = requests.collectorid
		 where cashcollector.passport = c.passport and requests.service like 'enc%')
from cashcollector c)

select avg(requests)
from cte

with recursive CollectorHierarchy (DirectorID, DirectorName, WorkerID, WorkerName, level) as
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
from cashcollector c join CollectorHierarchy ch
on c.director = ch.WorkerID
)

select DirectorID, DirectorName, WorkerID, WorkerName, Level
from CollectorHierarchy

-- минимальная дата рождения подчинённого для каждого директора 
select c.passport, c.fullname, min(c.birthdate) over (partition by c.director order by c.passport)
from cashcollector c
order by c.director


-- устранение дублей
insert into cashcollector (passport, fullname, birthdate, rank, region, requests, director) 
select passport + 1001, fullname, birthdate, rank, region, requests, director

select *
from (
select passport, fullname, birthdate, rank, region, requests, director,
	row_number() over (partition by fullname, birthdate, rank, region, requests, director) as num
from cashcollector
) t
where num = 1