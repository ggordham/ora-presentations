/* patch-drop.sql */

set serveroutput on size 999999

BEGIN
    FOR r_rec IN (SELECT name FROM dba_sql_patches WHERE sql_text LIKE '%PATCHTEST%')
    LOOP
         DBMS_SQLDIAG.DROP_SQL_PATCH(NAME=>r_rec.name, TRUE);
    END LOOP;
EXCEPTION
   WHEN OTHERS THEN 
    dbms_output.put_line(sqlerrm);
END;
/

COMMIT;

