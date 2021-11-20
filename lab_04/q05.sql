create or replace function func()
returns trigger
as
$$
	plpy.notice(f"{TD['old']['id']} was deleted")
$$  language plpython3u;
drop trigger if exists after_delete on requests;
create trigger after_delete after delete on requests
    for each row
    execute procedure func();

delete
from requests
where requestdate < '2020-01-01'