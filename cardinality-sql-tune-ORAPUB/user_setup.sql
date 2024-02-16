
CREATE USER perflab IDENTIFIED BY perf$lab 
  DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;

GRANT resource TO perflab;
GRANT connect TO perflab;
GRANT advisor TO perflab;
GRANT alter session TO perflab;
GRANT administer sql management object TO perflab;
GRANT select_catalog_role TO perflab;
-- GRANT create any directory TO perflab;

GRANT SELECT,UPDATE,INSERT,DELETE ON sh.customers TO perflab;
GRANT SELECT,UPDATE,INSERT,DELETE ON sh.sales TO perflab;
GRANT ALTER ON sh.customers TO perflab;
GRANT ALTER ON sh.sales TO perflab;
GRANT ANALYZE ANY TO perflab;

ALTER USER perflab QUOTA UNLIMITED ON users;


