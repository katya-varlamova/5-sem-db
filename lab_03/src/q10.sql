create or replace function func()
returns trigger
as
$$
begin
    raise notice 'just print instead of delete: %!', old;
    return old;
end
$$  language plpgsql;
drop trigger if exists instead_of on requests;
drop view if exists requestsview;
create view requestsview as
    select * from requests;
create trigger instead_of instead of delete on requestsview
    for each row
    execute procedure func();

delete
from requestsview
where requestdate < '2020-01-01'
