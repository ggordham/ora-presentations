
CONNECT / as sysdba

-- Create perflab user for demo tables etc..
CREATE USER perflab IDENTIFIED BY Perf$_Lab42
  DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;

GRANT resource TO perflab;
GRANT connect TO perflab;
GRANT select_catalog_role TO perflab;
GRANT administer sql management object TO perflab;
GRANT advisor TO perflab;
GRANT alter session TO perflab;
GRANT sqlt_user_role TO peflab;

GRANT SELECT ON co.products TO perflab;
GRANT SELECT ON co.orders TO perflab;
GRANT SELECT ON co.order_items TO perflab;
GRANT SELECT ON co.stores TO perflab;

GRANT SELECT ON sh.customers TO perflab;
GRANT SELECT ON oe.orders TO perflab;
GRANT SELECT ON oe.order_items TO perflab;
GRANT SELECT ON oe.product_information TO perflab;

ALTER USER perflab QUOTA UNLIMITED ON users;

GRANT READ ON hr.departments TO perflab;
GRANT READ ON hr.employees TO perflab;
-- GRANT READ ON hr.roles TO perflab;
GRANT READ ON hr.jobs TO perflab;
GRANT READ ON hr.locations TO perflab;
GRANT READ ON hr.regions TO perflab;
GRANT READ ON hr.countries TO perflab;
GRANT READ ON hr.job_history TO perflab;


-- remove our q1 example statement from the ASTS so that it does not show up for tuning advisor
EXEC DBMS_SQLTUNE.DELETE_SQLSET(sqlset_name => 'SYS_AUTO_STS', basic_filter => 'sql_id = ''9bpjmtthj7f41''');
COMMIT;

@connect.sql

-- Enable ORDS in the webdba schema
BEGIN
  ORDS.enable_schema(
    p_enabled             => TRUE,
    p_schema              => 'PERFLAB',
    p_url_mapping_type    => 'BASE_PATH',
    p_url_mapping_pattern => 'perflab',
    p_auto_rest_auth      => FALSE
  );
    
  COMMIT;
END;
/

