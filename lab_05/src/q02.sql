drop table CashCollector_d;
drop table temp;
create table if not exists Cashcollector_d (
                                             passport bigint,
                                             fullName varchar(30),
    birthDate date,
    rank varchar(30),
    region integer,
    requests integer,
    director bigint
    );
alter table Cashcollector_d add primary key(passport);
alter table Cashcollector_d add constraint birthDate check(birthDate < '2001-09-18' and not null);
alter table Cashcollector_d add constraint passport check (passport>=0 and passport <= 9999999999);
alter table Cashcollector_d add constraint director check (director>=0 and director <= 9999999999);
alter table Cashcollector_d add constraint fullName check (not null);
alter table Cashcollector_d add constraint region check (region > 0 and region < 86);

CREATE TABLE temp (
    data jsonb
);
\COPY temp (data) FROM 'data/cashcollector.json';
INSERT INTO CashCollector_d(passport, fullName, birthDate, rank, region, requests, director)
select
  cast(data->>'passport' as bigint),
  data->>'fullname',
  cast(data->>'birthdate' as date),
  data->>'rank',
  cast(data->>'region' as int),
  cast(data->>'requests' as int),
  cast(data->>'director' as bigint)
FROM temp;

select * from CashCollector_d;

