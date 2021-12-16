drop table CashCollector;
create table if not exists CashCollector (
	passport bigint,
	fullName varchar(30),
	birthDate date,
    rank varchar(30),
    region integer,
    requests integer, 
    director bigint
);
alter table CashCollector add primary key(passport);
alter table CashCollector add constraint birthDate check(birthDate < '2001-09-18' and not null);
alter table CashCollector add constraint passport check (passport>=0 and passport <= 9999999999);
alter table CashCollector add constraint director check (director>=0 and director <= 9999999999);
alter table CashCollector add constraint fullName check (not null);
alter table CashCollector add constraint region check (region > 0 and region < 86);
