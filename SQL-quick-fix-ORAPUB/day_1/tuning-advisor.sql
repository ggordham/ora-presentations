/* tuning-advisor.sql */

SET ECHO OFF
set serveroutput on
set DEFINE ON

var task_name varchar2(30)

PROMPT
PROMPT First we will run the tuning advisor
PROMPT

SET ECHO ON
EXEC :task_name := dbms_sqltune.create_tuning_task(sql_id=>'&1');

EXEC dbms_sqltune.execute_tuning_task(:task_name);

select :task_name from dual;

SET ECHO OFF

SET linesize 180
SET longchunksize 180
SET pagesize 900
SET long 1000000

PROMPT
PROMPT This is the report from the tuning advisor run
PROMPT

SELECT dbms_sqltune.report_tuning_task(:task_name) FROM dual;


PROMPT
PROMPT Now we will accept the advisor recomendation and it will create a
PROMPT   SQL profile
PROMPT

SET ECHO ON
SET SERVEROUTPUT ON

execute dbms_sqltune.accept_sql_profile(task_name => :task_name, task_owner => user, replace => TRUE);

SET ECHO OFF
