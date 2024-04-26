
CONNECT / as sysdba

CREATE USER perflab IDENTIFIED BY perf$lab
  DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;

GRANT resource TO perflab;
GRANT connect TO perflab;
GRANT select_catalog_role TO perflab;
GRANT administer sql management object TO perflab;
GRANT advisor TO perflab;
GRANT alter session TO perflab;

ALTER USER perflab QUOTA UNLIMITED ON users;

-- remove our q1 example statement from the ASTS so that it does not show up for tuning advisor
EXEC DBMS_SQLTUNE.DELETE_SQLSET(sqlset_name => 'SYS_AUTO_STS', basic_filter => 'sql_id = ''9bpjmtthj7f41''');
COMMIT;

