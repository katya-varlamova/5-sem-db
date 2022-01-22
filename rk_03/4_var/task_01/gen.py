from faker import Faker
from random import randint
from random import uniform
from random import choice

faker = Faker()
MAX_N = 10
weekdays = ['mon', 'tue', 'wed', 'thur', 'fri', 'sat', 'sun']
wd = ['09:00', '09:15', '09:30']
dep = ['it', 'bank', 'trades']
def gen_data():
    
    for i in range(MAX_N):
        print("(" +
              str(i) +
              "," +
              "'" +
              faker.name() +
              "', " +
              "'" +
              str(faker.date_between('-40y', '-21y')) + # date_this_month
              "', " +
              "'" +
              str(dep[randint(0, 2)]) +
              "'" +
              "),"
              )

gen_data()
