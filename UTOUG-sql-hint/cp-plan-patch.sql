/* cp-plan-patch.sql */

connect / as sysdba

set serveroutput on format wrapped

DECLARE
  hints        VARCHAR2(4000) := '';
  l_patch_name VARCHAR2(4000);
  v_sql        CLOB;

  CURSOR c1 IS
   SELECT  extractValue(value(h),'.') AS hint
   FROM    v$sql_plan sp,
        TABLE(xmlsequence(
            extract(xmltype(sp.other_xml),'/*/outline_data/hint'))) h
   WHERE   sp.other_xml is not null
   AND     sql_id = '&2'   /* Take outline from this SQL */
   AND     child_number = 0;
 BEGIN
  FOR r IN c1
  LOOP
      hints := hints || ' ' || r.hint;
  END LOOP;
      l_patch_name := sys.dbms_sqldiag.create_sql_patch(
                   sql_id    => '&1',
                   hint_text => hints,
                   name      =>'sql_&1._patch');

  DBMS_OUTPUT.PUT_LINE(' Patch created: '||l_patch_name);
END;
/


