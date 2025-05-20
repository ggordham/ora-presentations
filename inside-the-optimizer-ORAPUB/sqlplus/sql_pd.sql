
set long 9999
column directive_id format 999999999999999999999
column spd_text format a50
column internal_state format a15
column object_name format a12
column subobject_name format a12
column notes format a30

set echo on
set feedback on

select pd.directive_id, pd.reason, pd.state, pdo.object_name, pdo.subobject_name, pdo.num_rows,
    TO_CHAR (pd. last_used, 'YYYY-MM-DD') As last_used_day, pd.notes, pdo.notes
  from dba_sql_plan_directives pd, dba_sql_plan_dir_objects pdo
  where pd.directive_id = pdo.directive_id
     and pdo.owner = 'SH';
     and pdo.object_name = ' CUSTOMERS';
     -- and existsNode (pd.notes,'//text () [contains(.,"&1")]') = 1;

