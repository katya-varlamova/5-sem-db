import peewee as pw
from playhouse.db_url import connect
import json
db = connect("postgresext://postgres:pass@localhost:5433/rk3")
class BaseModel(pw.Model):
    class Meta:
        database = db
        db_table = 'worker'

class worker(BaseModel):
    id = pw.IntegerField(primary_key=True)
    fullname = pw.CharField()
    birthdate = pw.DateField()
    dep = pw.CharField()
class tab(BaseModel):
    wid = pw.ForeignKeyField(worker, to_field = 'id', db_column='wid')
    wdate = pw.DateField()
    wd = pw.CharField()
    wtime = pw.TimeField()
    wtype = pw.IntegerField()
def print_answ(cur):
    rows = cur.fetchall()
    for row in rows:
        for i in row:
            print(i, end = " ")
        print()
def q1():
    for rec in (worker
                .select(worker.id.alias('woid'))
                .where('09:05' >=
                    (tab
                    .select(pw.fn.min(tab.wtime)
                    .join(worker)
                    .where(worker.id == woid and '2021-12-14' == tab.wdate and tab.wtype == 1)))
                    )):
            print(rec.id)
    print("----------------")
    cur = db.cursor()
    cur.execute("select wo.id\
from worker wo\
where '09:05' >= (\
select min(t.wtime)\
from tab t join worker w on t.wid = w.id\
where w.id = wo.id and '2021-12-14' = t.wdate and t.wtype = 1);")
    print_answ(cur)


def q2():
    cur = db.cursor()
    cur.execute("select wid, (lag(wtime) over (partition by tab.wid)) as la\
from tab\
where la > '0:10'")
    print_answ(cur)

def q3():
    for rec in (worker
                .select(worker.id.alias('woid'))
                .where('08:00' >=
                    (tab
                    .select(pw.fn.min(tab.wtime)
                    .join(worker)
                    .where(worker.id == woid and worker.dep == 'bank' and tab.wtype == 1)))
                    )):
            print(rec.id)
    print("----------------")
    cur = db.cursor()
    cur.execute("select wo.id\
from worker wo\
where '08:00' >= (\
select min(t.wtime)\
from tab t join worker w on t.wid = w.id\
where w.id = wo.id and t.wtype = 1 and w.dep = 'bank')")
    print_answ(cur)

q1()
q2()
q3()
