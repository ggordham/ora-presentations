
connect / as sysdba

set echo on
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
   AND     sql_id = 'bshak75293cfs'   /* Take outline from this SQL */
   AND     child_number = 0;
 begin
  for c in c1
  loop
     hints := hints || ' ' ||c.hint;
  end loop;

  l_patch_name := sys.dbms_sqldiag.create_sql_patch(
                                sql_id    => 'afbaqn1zcxs7c',    /* Apply to this SQL */
                                hint_text => hints,
                                name      =>'q2_patch');

END;
/


