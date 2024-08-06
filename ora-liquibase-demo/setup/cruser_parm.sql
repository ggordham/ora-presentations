
PROMPT User to create &1

CREATE USER &1 IDENTIFIED BY &1._pa55wd
      DEFAULT TABLESPACE "USERS"
      TEMPORARY TABLESPACE "TEMP";

GRANT "RESOURCE" TO &1;
GRANT "XDBADMIN" TO &1;

ALTER USER &1 DEFAULT ROLE ALL;

GRANT CREATE SESSION TO &1;
GRANT UNLIMITED TABLESPACE TO &1;
GRANT CREATE SYNONYM TO &1;
GRANT CREATE VIEW TO &1;
GRANT CREATE DATABASE LINK TO &1;
GRANT CREATE MATERIALIZED VIEW TO &1;
GRANT QUERY REWRITE TO &1;

GRANT EXECUTE ON "SYS"."DBMS_STATS" TO &1;
GRANT SELECT ON "HR"."COUNTRIES" TO &1;
GRANT REFERENCES ON "HR"."COUNTRIES" TO &1;
GRANT SELECT ON "HR"."LOCATIONS" TO &1;
GRANT REFERENCES ON "HR"."LOCATIONS" TO &1;
GRANT SELECT ON "HR"."DEPARTMENTS" TO &1;
GRANT SELECT ON "HR"."JOBS" TO &1;
GRANT SELECT ON "HR"."EMPLOYEES" TO &1;
GRANT REFERENCES ON "HR"."EMPLOYEES" TO &1;
GRANT SELECT ON "HR"."JOB_HISTORY" TO &1;
GRANT READ ON DIRECTORY "SS_OE_XMLDIR" TO &1 WITH GRANT OPTION;
GRANT WRITE ON DIRECTORY "SS_OE_XMLDIR" TO &1 WITH GRANT OPTION;
GRANT READ ON DIRECTORY "SUBDIR" TO &1 WITH GRANT OPTION;
GRANT WRITE ON DIRECTORY "SUBDIR" TO &1 WITH GRANT OPTION;

ALTER USER &1 QUOTA UNLIMITED ON "USERS";


