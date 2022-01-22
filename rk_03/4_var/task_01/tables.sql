
CREATE TABLE worker (
                          id int PRIMARY KEY,
                          fullname VARCHAR NOT NULL,
                          birthdate DATE NOT NULL,
                          dep VARCHAR NOT NULL
);

CREATE TABLE tab (
                       wid INT NOT NULL references worker(id),
                       wdate DATE NOT NULL,
                       wd VARCHAR NOT NULL,
                       wtime TIME NOT NULL,
                       wtype INT NOT NULL
);

INSERT INTO worker (id, fullname, birthdate, dep) VALUES
(0,'Nathan Miller', '1986-12-16', 'bank'),
(1,'Amy Clay', '1993-08-15', 'it'),
(2,'Monique Carr', '1995-06-03', 'trades'),
(3,'Ariana Jenkins', '1990-11-12', 'trades'),
(4,'Joel Navarro', '1982-05-17', 'bank'),
(5,'Paul Soto', '1989-01-27', 'trades'),
(6,'Aaron Manning', '1989-02-24', 'bank'),
(7,'Emily Ayala', '1994-11-26', 'it'),
(8,'Carolyn Juarez', '1991-09-13', 'bank'),
(9,'Angelica Garrison', '1992-06-15', 'bank');

INSERT INTO tab (wid, wdate, wd, wtime, wtype) VALUES
(1, '2021-12-14', 'mon', '9:00', 1),
(1, '2021-12-14', 'mon', '9:20', 2),
(1, '2021-12-14', 'mon', '9:25', 1),
(2, '2021-12-14', 'mon', '9:05', 1);

create or replace function getworkers(d date)
returns table(fn varchar, bd date)
as
$$
begin
return query
select worker.fullname, worker.birthdate
from worker
where worker.id not in (
    select distinct w.id
    from tab t join worker w on t.wid = w.id
    where d = t.wdate and t.wtype = 1
);
end;
$$
LANGUAGE PLPGSQL;

select * from getworkers('2021-12-14');