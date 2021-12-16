from faker import Faker
from random import randint
from random import uniform
from random import choice
import datetime
import sys
import json
MAX_N = 10

rank = ["major", "ordinary"]
passports = []
tins = []
service = ["delivery of the exchange", "encashment"]
def generate_cashCollector():
    faker = Faker()
    f = open(str(sys.argv[1]) + '_collectors_' + str(datetime.datetime.now().strftime("%d-%m-%Y_%H:%M:%S")) + '.json', 'w')
    global passports
    f.write('[\n')
    passports = [faker.unique.pyint(4500000000, 4599999999) for i in range(MAX_N)]
    for i in range(MAX_N):
        rank_ind = randint(0, 1)
        region = randint(1, 85)
        obj = {}
        obj['passport'] = passports[i]
        obj['fullname'] = faker.name()
        obj['birthdate'] = str(faker.date_between('-40y', '-21y'))
        obj['rank'] = rank[rank_ind]
        obj['region'] = region
        obj['requests'] = randint(1, 9)
        if (i != 0):
            obj['director'] = passports[(i - 1) // 2]
        else:
            obj['director'] = None

        if i != MAX_N - 1:
            f.write(json.dumps(obj) + ', \n')
        else:
            f.write(json.dumps(obj) + '\n')
    f.write(']')
    f.close()

generate_cashCollector()

