connect / as sysdba

/*
declare
   v_sql CLOB;
begin
   select sql_fulltext 
   into v_sql 
   from   v$sqlarea 
   where  sql_id='bdrzvmxvcju4y';

   sys.dbms_sqldiag_internal.i_create_patch(
      sql_text  =>v_sql,
      hint_text =>'IGNORE_OPTIM_EMBEDDED_HINTS', 
      creator =>'SYS',
      name      =>'q1_patch');
end;
/
*/

prompt Put a patch in to ignore the embeded hint
prompt Press Enter to continue:
accept next1

set echo on
DECLARE
  l_patch_name VARCHAR2(4000);
BEGIN
  l_patch_name := sys.dbms_sqldiag.create_sql_patch(
                                sql_id => 'bdrzvmxvcju4y',
                                hint_text =>'IGNORE_OPTIM_EMBEDDED_HINTS', 
                                name      =>'q1_patch');
END;
/

set echo off

