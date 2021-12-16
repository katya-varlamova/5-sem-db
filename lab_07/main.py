import peewee as pw
from playhouse.db_url import connect
import json
db = connect("postgresext://postgres:rfktdf17@localhost:5433/postgres")

class BaseModel(pw.Model):
    class Meta:
        database = db
        db_table = 'cashcollector'
        
class Cashcollector(BaseModel):
    passport = pw.BigIntegerField(primary_key=True)
    fullname = pw.CharField()
    birthdate = pw.DateField()
    rank = pw.CharField()
    region = pw.IntegerField()
    requests = pw.IntegerField()
    director = pw.BigIntegerField(null = True)    
    
def create_collectors(file_name):
    Cashcollector.create_table()
    file = open(file_name, 'r')

    for line in file:
        arr = line.split(':')
        arr[0] = int(arr[0])
        arr[4] = int(arr[4])
        arr[5] = int(arr[5])
        try:
            arr[6] = int(arr[6])
        except:
            arr[6] = None
        Cashcollector.create(passport = arr[0],
                          fullname = arr[1],
                          birthdate = arr[2],
                          rank = arr[3],
                          region = arr[4],
                          requests = arr[5],
                          director = arr[6])
class Requests(BaseModel):
    id = pw.PrimaryKeyField()
    collectorid = pw.ForeignKeyField(Cashcollector, to_field = 'passport', db_column='collectorid')
    requestdate = pw.DateField()
    address = pw.CharField()
    service = pw.CharField()
    
def create_requests(file_name):
    Requests.create_table()
    file = open(file_name, 'r')

    for line in file:
        arr = line.split(':')
        arr[0] = int(arr[0])
        arr[1] = int(arr[1])
        Requests.create(collectorid = arr[1],
                          requestdate = arr[2],
                          address = arr[3],
                          service = arr[4])
    
    
def req_1():
    for rec in (Cashcollector
                .select(Cashcollector.fullname, Requests.requestdate)
                .join(Requests)
                .where(Requests.requestdate < '2019-11-18')):
        print(rec.fullname, rec.requests.requestdate)
def req_2():
    for rec in (Requests
                .select(Requests.collectorid, pw.fn.count(Requests.id).alias('count'))
                .join(Cashcollector)
                .where(Cashcollector.rank == 'major')
                .group_by(Requests.collectorid)):
        print(rec.collectorid, rec.count)
def req_3():
    rg = (Requests
          .select(Requests.requestdate.alias('rdate'), pw.fn.count(Requests.id).alias('count'))
          .group_by(Requests.requestdate)
          .cte('rg', columns = ('rdate', 'count'))
          )
    for i in (rg
              .select_from(rg.c.rdate, rg.c.count)
              .where(rg.c.count > 5)
              .order_by(rg.c.count)):
        print(i.rdate, i.count)
    
def req_4():
    for i in (Cashcollector
              .select(Cashcollector.fullname)
              .where(Cashcollector.birthdate < '1982-01-01')
              .order_by(Cashcollector.fullname)):
        print(i.fullname)
def req_5():
    for i in (Cashcollector
              .select(Cashcollector.fullname)
              .where(
                  (Requests
                  .select(pw.fn.count(Requests.id))
                  .where(Cashcollector.passport == Requests.collectorid)
                  .group_by(Requests.collectorid)) > 3
                  )
              .order_by(Cashcollector.fullname)):
        print(i.fullname)
def req_insert():
    q = Cashcollector.select(pw.fn.max(Cashcollector.passport))
    maxid = q[0].max
    Cashcollector.insert(passport=maxid + 1, fullname='Katya Varlamova', birthdate='2001-08-17', rank = 'major', region =77, requests=10, director = maxid).execute()
def req_update():
    Cashcollector.update(fullname='Ekaterina Varlamova').where(Cashcollector.fullname=='Katya Varlamova').execute()
def req_delete():
    Cashcollector.delete().where(Cashcollector.fullname=='Ekaterina Varlamova').execute()
def linq_to_object():
    req_1()
    req_2()
    req_3()
    req_4()
    req_5()
    
def linq_to_json():
    # read
    data = []
    with open("cashcollector.json", "r") as read_file:
        for line in read_file:
           data.append(json.loads(line))
           
    maxid = data[0]["passport"]
    # update
    for i in range(len(data)):
        if data[i]["passport"] > maxid:
            maxid = data[i]["passport"]
        data[i]["requests"] = str(int(data[i]["requests"]) + 1)
        
    # append
    data.append({'passport': maxid + 1, 'fullname': 'Katya Varlamova', 'birthdate': '2001-08-17', 'rank': 'major', 'region': 77, 'requests': '10', 'director': maxid})
    
    # write
    with open("cashcollector.json", "w") as write_file:
        for i in range(len(data)):
            write_file.write(json.dumps(data[i]) + '\n')

def linq_to_sql():
    req_4()
    
    req_1()
    
    req_insert()
    req_update()
    req_delete()

    cur = db.cursor()
    cur.callproc('getAge', ['1999-10-17',])
    rows = cur.fetchall()
    for row in rows:
        for i in row:
            print(i, end = " ")
        print()
    cur.close()
    
Requests.drop_table()
Cashcollector.drop_table()

create_collectors("collectors.csv")
create_requests("requests.csv")
linq_to_object()
linq_to_json()
linq_to_sql()
