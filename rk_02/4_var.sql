create DATABASE RK2;

\c rk2;

create table if not exists Employees(
                                        id int primary key ,
                                        FIO VARCHAR(50),
    birth date,
    yearsOfWork int,
    phoneNumber varchar(11)
    );

create table if not exists Duties(
                                     id int primary key,
                                     ddate date,
                                     tBegin int,
                                     tEnd int
);

create table if not exists Security(
                                       id int primary key ,
                                       emId int references Employees(id),
    name varchar(30),
    address varchar(200)
    );

create table if not exists ED (
                                  id int primary key,
                                  eid int references Employees(id),
    did int references Duties(id)
    );

INSERT into employees values (0, 'A B R', '1989-02-01', 13, '34234567912');
INSERT into employees values (1, 'F B V', '1999-03-01', 2,   '34237462913');
INSERT into employees values (2, 'H B H', '1976-04-02', 5,   '56212689914');
INSERT into employees values (3, 'J A J', '1951-05-03', 7,   '89230235115');
INSERT into employees values (4, 'K A C', '2001-06-14', 4,   '56583624916');
INSERT into employees values (5, 'L B R', '2012-07-05', 20, '12012567917');
INSERT into employees values (6, 'Q B D', '2017-08-16', 15, '90234503128');
INSERT into employees values (7, 'W T W', '2005-09-07', 3,    '71212367919');
INSERT into employees values (8, 'E A G', '1991-10-18', 8,    '65254823410');
INSERT into employees values (9, 'Y A K', '1982-11-09', 14,  '45105679111');

INSERT into duties values (0, '2021-06-01' ,  8, 16);
INSERT into duties values (1, '2021-06-02' ,  8, 16);
INSERT into duties values (2, '2021-06-03' ,  8, 16);
INSERT into duties values (3, '2021-07-04' ,  8, 16);
INSERT into duties values (4, '2021-06-05' ,  8, 16);
INSERT into duties values (5, '2021-05-06' ,  16, 20);
INSERT into duties values (6, '2021-08-07' ,  16, 20);
INSERT into duties values (7, '2021-06-08' ,  16, 20);
INSERT into duties values (8, '2021-05-09' ,  20, 24);
INSERT into duties values (9, '2021-05-10' ,  20, 24);

INSERT into ED values (0, 0, 0);
INSERT into ED values (1, 1, 1);
INSERT into ED values (2, 2, 2);
INSERT into ED values (3, 3, 3);
INSERT into ED values (4, 4, 4);
INSERT into ED values (5, 5, 5);
INSERT into ED values (6, 6, 6);
INSERT into ED values (7, 7, 7);
INSERT into ED values (8, 8, 8);
INSERT into ED values (9, 9, 9);

INSERT into security values (0, 0, 'Security1',  'street1');
INSERT into security values (1, 1, 'Security2', 'street2');
INSERT into security values (2, 2, 'Security3', 'street3');
INSERT into security values (3, 3, 'Security4', 'street4');
INSERT into security values (4, 4, 'Security5', 'street5');
INSERT into security values (5, 5, 'Security6', 'street6');
INSERT into security values (6, 6, 'Security7', 'street7');
INSERT into security values (7, 7, 'Security8', 'street8');
INSERT into security values (8, 8, 'Security9', 'street9');
INSERT into security values (9, 9, 'Security10', 'street10');

2 задание
-- определить смену дежурства по времени начала
select id,
       case
           when tBegin = 8 then 'first shift'
           when tBegin = 16 then 'second shift'
           else 'third shift'
           end
from Duties;

-- уменьшить время конца самого позднего дежурства на 1
update Duties
set tEnd = tEnd - 1
where tEnd = (
    select max(tEnd)
    from Duties
);

-- среднее время дежурства работников, стаж которых более 2 лет, в разрезе по стажу
select yearsOfWork, avg(tEnd - tBegin)
from Employees e join ED on e.id = ED.eid join Duties d on d.id = ED.did
group by yearsOfWork
having yearsOfWork > 2;


3 задание
create or replace procedure deleteDDLtriggers(cnt inout int)
as
$$
declare rec record;
    declare cur cursor for
            (select * from pg_event_trigger);
begin
open cur;
fetch next from cur into rec;
while (found)
        loop
            if rec.evtevent = 'ddl_command_start' or rec.evtevent = 'ddl_command_end'
            then
                execute 'drop event trigger ' || rec.evtname;
                cnt = cnt  + 1;
end if;
fetch next from cur into rec;
end loop;
end;
$$ language plpgsql;

CREATE OR REPLACE FUNCTION fn_ddl_trigger()
    RETURNS event_trigger
AS $$
BEGIN
    RAISE EXCEPTION 'Current running DDL command is : % ', tg_tag;
END;

$$ LANGUAGE plpgsql;
CREATE EVENT TRIGGER ddl_trigger ON ddl_command_start
  EXECUTE PROCEDURE fn_ddl_trigger();

do
$$
    declare cnt int;
begin
        cnt = 0;
call deleteDDLtriggers(cnt);
raise notice 'num of deleted triggers: %', cnt;
end;
$$ language plpgsql;
 