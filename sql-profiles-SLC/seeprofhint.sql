
-- following can be run as user with proper grants
SELECT p.created, p.name, p.sql_text, 
        extractvalue(VALUE(hint), '.') AS hint
  FROM dbmshsxp_sql_profile_attr h, dba_sql_profiles p, 
       TABLE(xmlsequence(extract(xmltype(h.comp_data), '/outline_data/hint'))) hint
  WHERE p.name = h.profile_name;


-- This query needs to be run by sysdba since it looks at sqlobj data
select hint as outline_hints
from (select p.name, p.signature, p.category, row_number()
over (partition by sd.signature, sd.category order by sd.signature) row_num,
extractValue(value(t), '/hint') hint
from sqlobj$data sd, dba_sql_profiles p,
table(xmlsequence(extract(xmltype(sd.comp_data),
'/outline_data/hint'))) t
where sd.obj_type = 1
and p.signature = sd.signature
and p.category = sd.category
and p.name like ('&&profile_name'))
order by row_num;
