
CONNECT / as sysdba

CREATE USER perflab IDENTIFIED BY perf$lab 
  DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;

GRANT resource TO perflab;
GRANT connect TO perflab;
GRANT select_catalog_role TO perflab;

ALTER USER perflab QUOTA UNLIMITED ON users;

EXIT
