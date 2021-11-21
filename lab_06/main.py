import psycopg2
PASSWORD = "rfktdf17"
def connect_to_postgresql():
    con = psycopg2.connect(
        database="postgres",
        user="postgres",
        password=PASSWORD,
        host="127.0.0.1",
        port="5433"
    )
    return con
def print_answ(cur):
    rows = cur.fetchall()
    for row in rows:
        for i in row:
            print(i, end = " ")
        print()
def print_menu():
    print("\n0. Выход\n\
1. Скалярный запрос: получить имя инкассатора по id\n\
2. Запрос с несколькими соединениями (JOIN): получить таблицу, состоящую из 2 столбцов:\
имя инкассатора и точка, на которую он выезжал по 17 числам месяца\n\
3. Запрос с ОТВ(CTE) и оконными функциями: ;\n\
4. Запрос к метаданным: получить по имени таблицы данные об индексах;\n\
5. Вызвать скалярную функцию: по дате получить количество лет\n;\
6. Вызвать многооператорную или табличную функцию \n\
7. Вызвать хранимую процедуру \n\
8. Вызвать системную функцию или процедуру;\n\
9. Создать таблицу в базе данных\n\
10. Выполнить вставку данных в созданную таблицу.\n")

con = connect_to_postgresql()
print_menu()
num = int(input("Введите команду: "))
cur = con.cursor()
while(num != 0):
    if num == 1:
        idcc = input("ID инкассатора: ")
        cur.execute("select fullname from cashcollector where passport = " + idcc)
        print_answ(cur)
    elif num == 2:
        cur.execute("select c.fullname, o.address from cashcollector c join requests r on c.passport =\
r.collectorid join objects o on r.objectid = o.id where date_part('day', r.requestdate) = 17")
        print_answ(cur)
    elif num == 3:
        cur.execute("with cte (passport, cnt) as\
(select c.passport as passport, count (r.id) over (partition by c.passport) as cnt\
 from cashcollector c join requests r on c.passport = r.collectorid\
 where r.service like 'enc%')\
select * from cte;")
        print_answ(cur)
    elif num == 4:
        tblname = input("имя таблицы: ")
        cur.execute("select * from pg_indexes\
                where tablename = '" + tblname + "'")
        print_answ(cur)
    elif num == 5:
        cur.callproc('getAge', ['1999-10-17',])
        print_answ(cur)
    elif num == 6:
        cur.callproc('deliverers', [])
        print_answ(cur)
    elif num == 7:
        cur.execute('call print_major_collectors()')
    elif num == 8:
        cur.callproc('current_database', [])
        print_answ(cur)
    elif num == 9:
        cur.execute('create table if not exists BankWorker (\
	passport bigint primary key,\
	fullName varchar(30),\
	birthDate date)');
    elif num == 10:
        cur.execute("insert into BankWorker (passport, fullname, birthdate) \
values ('4621556324','katya varlamova', '2001-08-17')");
        cur.execute("select * from BankWorker")
        print_answ(cur)
    else:
        print("Неверная команда!\n")
    print_menu()
    num = int(input("Введите команду: "))

con.close()
