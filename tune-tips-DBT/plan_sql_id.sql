
set linesize 250
set trims on
set tab off
set tab off
set pagesize 1000
column plan_table_output format a180

SET SERVEROUTPUT ON

BEGIN


  FOR r_cursor IN (
      SELECT sql_id, child_number
        FROM v$sql
        WHERE sql_id = '&1')
  LOOP 

    FOR r_plan IN (
        SELECT plan_table_output
          FROM table(DBMS_XPLAN.DISPLAY_CURSOR(
                      SQL_ID=> r_cursor.sql_id,
                      CURSOR_CHILD_NO=>r_cursor.child_number,
                      FORMAT=>'ALL +cost +bytes +OUTLINE'))
      )
      LOOP
          DBMS_OUTPUT.PUT_LINE(r_plan.plan_table_output);
      END LOOP;
  END LOOP;
END;
/


