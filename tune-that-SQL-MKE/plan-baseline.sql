/* plan_baseline.sql */

set linesize 250
set trims on
set tab off
set tab off
set pagesize 1000
column plan_table_output format a180

SET SERVEROUTPUT ON

BEGIN

  FOR r_cursor IN (
      SELECT sql_handle, plan_name 
        FROM dba_sql_plan_baselines 
        WHERE DBMS_SQL_TRANSLATOR.SQL_ID(sql_text) = '&1')
  LOOP 

    FOR r_plan IN (
        SELECT plan_table_output
          FROM TABLE(DBMS_XPLAN.DISPLAY_SQL_PLAN_BASELINE(
                       sql_handle => r_cursor.sql_handle, 
                       plan_name => r_cursor.plan_name, 
                       formaT => 'ALL +cost +bytes +OUTLINE'))
                       -- 'typical')) 
        )
        LOOP 
          DBMS_OUTPUT.PUT_LINE(r_plan.plan_table_output);
      END LOOP;
  END LOOP;
END;
/

