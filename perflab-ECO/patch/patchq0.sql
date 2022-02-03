
prompt Here we will change to the SYS user and install the SQL patch
prompt Press Enter to continue:
accept next1


connect / as sysdba

/*
declare
   v_sql CLOB;
   v_hint CLOB;
begin
   v_hint :='FULL(@"SEL$1" "TAB1"@"SEL$1")';

   select sql_fulltext
   into   v_sql
   from   v$sqlarea
   where  sql_id='37090abayamah';

   sys.dbms_sqldiag_internal.i_create_patch(
      sql_text  =>v_sql,
      hint_text =>v_hint,
      creator =>'SYS',
      name      =>'q0_patch');
end;
/
*/

set echo on
DECLARE
  l_patch_name VARCHAR2(4000);
BEGIN
  l_patch_name := sys.dbms_sqldiag.create_sql_patch(
                                -- sql_id => '37090abayamah',
                                sql_id => 'adps0u414xj2s',
                                hint_text => 'FULL(@"SEL$1" "TAB1"@"SEL$1")',
                                name      =>'q0_patch');
END;
/

set echo off
