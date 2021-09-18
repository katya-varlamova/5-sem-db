from faker import Faker
from random import randint
from random import uniform
from random import choice

MAX_N = 1000

rank = ["major", "ordinary"]
passports = []
tins = []
service = ["delivery of the exchange", "encashment"]
def generate_cashCollector():
    faker = Faker()
    f = open('collectors.csv', 'w')
    global passports
    passports = [faker.unique.pyint(4500000000, 4599999999) for i in range(MAX_N)]
    for i in range(MAX_N):
        rank_ind = randint(0, 1)
        region = randint(1, 85)
        line = "{0}:{1}:{2}:{3}:{4}\n".format(passports[i],
                                                  faker.name(),
                                                  faker.date_of_birth(),
                                                  rank[rank_ind],
                                                  region)
        f.write(line)
    f.close()
def generate_LegalEntity():
    faker = Faker()
    f = open('entities.csv', 'w')
    global tins
    tins = [faker.unique.pyint(2000000000, 2099999999) for i in range(MAX_N)]
    
    for i in range(MAX_N):
        regCode = randint(350000000, 409999999)
        line = "{0}:{1}:{2}:{3}:{4}\n".format(tins[i],
                                              regCode,
                                              faker.company(),
                                              faker.name(),
                                              faker.street_address())
        f.write(line)
    f.close()
def generate_Objects():
    faker = Faker()
    f = open('objects.csv', 'w')
    for i in range(MAX_N):
        legalEntityID = tins[i % (MAX_N // 2)]
        line = "{0}:{1}:{2}:{3}\n".format(legalEntityID,
                                              faker.street_address(),
                                              faker.company(),
                                              faker.name())
        f.write(line)
    f.close()
def generate_Request():
    faker = Faker()
    f = open('requests.csv', 'w')
    for i in range(MAX_N):
        service_ind = randint(0, 1)
        line = "{0}:{1}:{2}:{3}:{4}\n".format(randint(1, MAX_N - 1),
                                              passports[i % (MAX_N // 2)],
                                              faker.date_this_month(),
                                              faker.street_address(),
                                              service[service_ind])
        f.write(line)
    f.close()
generate_cashCollector()
generate_LegalEntity()
generate_Objects()
generate_Request()
