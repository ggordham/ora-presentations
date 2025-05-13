/* mk-patch.sql */

set linesize 4000
set trimspool 0
set pagesize 0
set heading off
set wrap off
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
     IF c1%rowcount = 1 THEN
         hints := ''''||REPLACE(r.hint,'''','''''')||' ''';
     ELSE
         hints := hints || '||' || CHR(10)||'                               '|| ''''||REPLACE(r.hint,'''','''''')||' ''';
     END IF;
  END LOOP;
DBMS_OUTPUT.PUT_LINE('-- run the following block to create the patch');
DBMS_OUTPUT.PUT_LINE('DECLARE');
DBMS_OUTPUT.PUT_LINE('  pname VARCHAR2(4000);');
DBMS_OUTPUT.PUT_LINE('BEGIN');
DBMS_OUTPUT.PUT_LINE('');
DBMS_OUTPUT.PUT_LINE('  pname := sys.dbms_sqldiag.create_sql_patch(');
DBMS_OUTPUT.PUT_LINE('                   sql_id    => ''&1'',');
DBMS_OUTPUT.PUT_LINE('                   hint_text =>'|| hints||',');
DBMS_OUTPUT.PUT_LINE('                   name      =>''sql_&1._patch'');');
DBMS_OUTPUT.PUT_LINE('END;');
DBMS_OUTPUT.PUT_LINE('/');
DBMS_OUTPUT.PUT_LINE('-- end of patch block');

END;
/


