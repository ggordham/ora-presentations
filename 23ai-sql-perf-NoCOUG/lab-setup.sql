
CONNECT / as sysdba

CREATE USER perflab IDENTIFIED BY Perf$_Lab42
  DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;

GRANT resource TO perflab;
GRANT connect TO perflab;
GRANT select_catalog_role TO perflab;
GRANT administer sql management object TO perflab;
GRANT advisor TO perflab;
GRANT alter session TO perflab;
GRANT dba TO perflab;

GRANT SELECT ON co.orders TO perflab;
GRANT SELECT ON co.products TO perflab;
GRANT SELECT ON co.order_items TO perflab;

ALTER USER perflab QUOTA UNLIMITED ON users;

