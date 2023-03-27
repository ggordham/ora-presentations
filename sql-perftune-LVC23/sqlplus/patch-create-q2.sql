/* patch-create-q2.sql */

SET ECHO OFF

PROMPT
PROMPT connect as the SYS user to create the patch
PROMPT

CONNECT / AS SYSDBA


SET ECHO ON

declare
  hints varchar2(1024) := '';
  l_patch_name VARCHAR2(4000);
  v_sql CLOB;

  cursor c1 is
   SELECT  extractValue(value(h),'.') AS hint
   FROM    v$sql_plan sp,
        TABLE(xmlsequence(
            extract(xmltype(sp.other_xml),'/*/outline_data/hint'))) h
   WHERE   sp.other_xml is not null
   AND     sql_id = '&2'   /* Take outline from this SQL */
   AND     child_number = 0;
 begin
  for c in c1
  loop
     hints := hints || ' ' ||c.hint;
  end loop;

  l_patch_name := sys.dbms_sqldiag.create_sql_patch(
                                sql_id    => '&1',    /* Apply to this SQL */
                                hint_text => hints,
                                name      =>'sql_&1_patch');

END;
/

SET ECHO OFF

