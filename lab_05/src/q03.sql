create or replace function getEducation()
returns jsonb
as $$
begin
    return '{"university": "BMSTU", "degree" : "master"}';
end;
$$ language plpgsql;

alter table cashcollector add education jsonb;
update cashcollector
set education = getEducation();

select * from cashcollector;