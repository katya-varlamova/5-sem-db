select c.education->'university' is not null as has_education
from cashcollector c
where c.passport = '4514583967'