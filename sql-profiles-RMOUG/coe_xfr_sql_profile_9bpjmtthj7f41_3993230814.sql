SPO coe_xfr_sql_profile_9bpjmtthj7f41_3993230814.log;
SET ECHO ON TERM ON LIN 2000 TRIMS ON NUMF 99999999999999999999;
REM
REM $Header: 215187.1 coe_xfr_sql_profile_9bpjmtthj7f41_3993230814.sql 11.4.1.4 2022/12/08 csierra $
REM
REM Copyright (c) 2000-2010, Oracle Corporation. All rights reserved.
REM
REM AUTHOR
REM   carlos.sierra@oracle.com
REM
REM SCRIPT
REM   coe_xfr_sql_profile_9bpjmtthj7f41_3993230814.sql
REM
REM DESCRIPTION
REM   This script is generated by coe_xfr_sql_profile.sql
REM   It contains the SQL*Plus commands to create a custom
REM   SQL Profile for SQL_ID 9bpjmtthj7f41 based on plan hash
REM   value 3993230814.
REM   The custom SQL Profile to be created by this script
REM   will affect plans for SQL commands with signature
REM   matching the one for SQL Text below.
REM   Review SQL Text and adjust accordingly.
REM
REM PARAMETERS
REM   None.
REM
REM EXAMPLE
REM   SQL> START coe_xfr_sql_profile_9bpjmtthj7f41_3993230814.sql;
REM
REM NOTES
REM   1. Should be run as SYSTEM or SYSDBA.
REM   2. User must have CREATE ANY SQL PROFILE privilege.
REM   3. SOURCE and TARGET systems can be the same or similar.
REM   4. To drop this custom SQL Profile after it has been created:
REM      EXEC DBMS_SQLTUNE.DROP_SQL_PROFILE('coe_9bpjmtthj7f41_3993230814');
REM   5. Be aware that using DBMS_SQLTUNE requires a license
REM      for the Oracle Tuning Pack.
REM
WHENEVER SQLERROR EXIT SQL.SQLCODE;
REM
VAR signature NUMBER;
REM
DECLARE
sql_txt CLOB;
h       SYS.SQLPROF_ATTR;
BEGIN
sql_txt := q'[
select /* PROFTEST */ /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */ COUNT(*) from sales WHERE sale_date >= trunc(sysdate)
]';
h := SYS.SQLPROF_ATTR(
q'[BEGIN_OUTLINE_DATA]',
q'[IGNORE_OPTIM_EMBEDDED_HINTS]',
q'[OPTIMIZER_FEATURES_ENABLE('19.1.0')]',
q'[DB_VERSION('19.1.0')]',
q'[ALL_ROWS]',
q'[OUTLINE_LEAF(@"SEL$1")]',
q'[INDEX(@"SEL$1" "SALES"@"SEL$1" ("SALES"."SALE_DATE"))]',
q'[END_OUTLINE_DATA]');
:signature := DBMS_SQLTUNE.SQLTEXT_TO_SIGNATURE(sql_txt);
DBMS_SQLTUNE.IMPORT_SQL_PROFILE (
sql_text    => sql_txt,
profile     => h,
name        => 'coe_9bpjmtthj7f41_3993230814',
description => 'coe 9bpjmtthj7f41 3993230814 '||:signature||'',
category    => 'DEFAULT',
validate    => TRUE,
replace     => TRUE,
force_match => FALSE /* TRUE:FORCE (match even when different literals in SQL). FALSE:EXACT (similar to CURSOR_SHARING) */ );
END;
/
WHENEVER SQLERROR CONTINUE
SET ECHO OFF;
PRINT signature
PRO
PRO ... manual custom SQL Profile has been created
PRO
SET TERM ON ECHO OFF LIN 80 TRIMS OFF NUMF "";
SPO OFF;
PRO
PRO COE_XFR_SQL_PROFILE_9bpjmtthj7f41_3993230814 completed
