update cashcollector
set education = '{"university" : "MSU", "degree" : "master"}'::jsonb
where rank = 'major';

select * from cashcollector;