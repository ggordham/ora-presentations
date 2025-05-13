--
-- The bind variable is the wrong type for the query
-- since s_area is CHAR(4)
--
var bind1 number
exec :bind1 := 1

select t1.p_category, t2.tpmethod 
from products t1, products t2
where t1.prod_category || '_1' = 'SFD_1'
and   t2.method_typ != 'SEA'
union
select t3.p_category, t4.tpmethod
from products t3, sources t4
where t3.scid = t4.scid 
and   t4.carrier   = 'AAC'
and   t4.s_area    = :bind1;

set linesize 200
set tab off
set trims on
set pagesize 1000
column plan_table_output format a180

SELECT *
FROM table(DBMS_XPLAN.DISPLAY_CURSOR());

