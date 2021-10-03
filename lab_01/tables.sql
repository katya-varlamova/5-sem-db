
--select * from CashCollector where rank = 'major';
drop table Requests;
drop table Objects;
drop table CashCollector;
drop table LegalEntity;

create table if not exists CashCollector (
	passport bigint,
	fullName varchar(30),
	birthDate date,
    rank varchar(30),
    region integer,
    requests integer
);
alter table CashCollector add primary key(passport);
alter table CashCollector add constraint birthDate check(birthDate < '2001-09-18' and not null);
alter table CashCollector add constraint passport check (passport>=0 and passport <= 9999999999);
alter table CashCollector add constraint fullName check (not null);
alter table CashCollector add constraint region check (region > 0 and region < 86);


\copy CashCollector(passport, fullName, birthDate, rank, region, requests) from '/Users/kate/Desktop/db/lab_01/data/collectors.csv' delimiter ':' csv;

create table if not exists LegalEntity (
	tin bigint,
    regCode bigint,
	name varchar(60),
	director varchar(30),
    legalAddress varchar(50)
);
alter table LegalEntity add primary key(tin);
alter table LegalEntity add constraint name check(not null);
alter table LegalEntity add constraint tin check (tin>=0 and tin <= 9999999999);
alter table LegalEntity add constraint regCode check (regCode>=0 and regCode <= 999999999);
\copy LegalEntity(tin, regCode, name, director, legalAddress) from '/Users/kate/Desktop/db/lab_01/data/entities.csv' delimiter ':' csv;

create table if not exists Objects (
	id serial,
	legalEntityID bigint,
    address varchar(50),
    name varchar(60),
    director varchar(30)
);
alter table Objects add primary key(id);
alter table Objects add constraint id check(not null);
alter table Objects add foreign key (legalEntityID) references LegalEntity(tin);
alter table Objects add constraint name check(not null);
\copy Objects(legalEntityID, address, name, director) from '/Users/kate/Desktop/db/lab_01/data/objects.csv' delimiter ':' csv;


create table if not exists Requests (
	id serial,
	objectID int,
    collectorId bigint,
    requestDate date,
    address varchar(50),
    service varchar(30)
);
alter table Requests add primary key(id);
alter table Requests add constraint id check(not null);
alter table Requests add foreign key (objectID) references Objects(id);
alter table  Requests add constraint objectID check(not null);
alter table Requests add foreign key (collectorId) references CashCollector(passport);
alter table  Requests add constraint collectorId check(not null);
alter table Requests add constraint requestDate check (not null);
\copy  Requests(objectID, collectorId, requestDate, address, service) from '/Users/kate/Desktop/db/lab_01/data/requests.csv' delimiter ':' csv;

select 