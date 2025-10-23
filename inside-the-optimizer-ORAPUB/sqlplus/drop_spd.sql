/* drop_spd.sql */

/*
  Used to drop a specific set of SQL Plan Directives based
  on the schema and object name
*/

@@connect_sys.sql

col owner format a20
set serverout on
set verify off

SELECT owner, object_name,
       count(distinct directive_id) spd_count
  FROM dba_sql_plan_dir_objects 
  WHERE owner = '&1'
    AND object_name = '&2'
  GROUP BY owner, object_name;

declare dir_id dba_sql_plan_dir_objects.directive_id%type;
total_dir number;

/* input user to drop the SPDs from. If you want to drop all SPDs 
   in the database, remove where clause below and run */

cursor dir is 
    select distinct directive_id 
      from dba_sql_plan_dir_objects 
       where owner='&1'
         AND object_name = '&2';

begin
  open dir;
  loop
    fetch dir into dir_id;
    total_dir := dir%rowcount;
    exit when dir%notfound;
    dbms_spd.drop_sql_plan_directive(dir_id);
  end loop;
  dbms_output.put_line(total_dir||' directive(s) dropped');
  close dir;
end;
/
