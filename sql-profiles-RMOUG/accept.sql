
set echo on
set serveroutput on

execute dbms_sqltune.accept_sql_profile(task_name => :task_name, task_owner => user, replace => TRUE);

