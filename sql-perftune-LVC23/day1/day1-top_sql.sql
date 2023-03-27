/* top_sql.sql */

/*
  used to show the top SQL in the database.
   From Jeff Smith
   https://www.thatjeffsmith.com/archive/2016/10/top-sql-seeing-what-hurts-in-the-v4-2-instance-viewer/
   can be setup as a SQL CLI alias

   Will ask for top number of SQL's to show E.G. 100

   Note, pct of cpu seconds and elapsed seconds does not seem accurate.
*/

/*
-- Note this section commented out for SQL Developer WEB
--  These settings will work for SQLPlus command line
column CPU format a8
column ELAPSED format a8
column EXECS format a8
column PARSING_SCHEMA_NAME format a15
column MODULE format a10
column SQL format a25

set pagesize 999
set linesize 200

define n_sql = 100;
define schema_name = PERFLAB;

set pagesize 200
*/

SELECT
    inst_id, sql, parsing_schema_name, sql_id, plan_hash_value, optimizer_cost,
    executions_form execs, module, last_active_time_form,
      cpu_seconds_form cpu, elapsed_seconds_form elapsed, disk_reads, buffer_gets, 
      ROUND(cpu_seconds_prop*100,2) AS cpu_pct, ROUND(elapsed_seconds_prop*100,2) AS elap_pct, 
      ROUND(disk_reads_prop*100,2) AS dread_pct, ROUND(buffer_gets_prop*100,2) AS bget_pct, 
      ROUND(executions_prop*100,2) AS exec_pct
FROM
    (
        SELECT
            D.*
            ,ROWNUM ROW#
        FROM
            (
                SELECT
                    D.*
                FROM
                    (
                        SELECT
                            substr(SQL_TEXT, 1, 25) AS SQL
                            ,S.CPU_TIME / 1000000 AS CPU_SECONDS
                                ,CASE WHEN
                                    S.CPU_TIME < 1000
                                THEN
                                    '< 1 ms'
                                WHEN
                                    S.CPU_TIME < 1000000
                                THEN
                                    TO_CHAR(ROUND(S.CPU_TIME / 1000,1) )
                                     ||  ' ms'
                                WHEN
                                    S.CPU_TIME < 60000000
                                THEN
                                    TO_CHAR(ROUND(S.CPU_TIME / 1000000,1) )
                                     ||  ' s'
                                ELSE
                                    TO_CHAR(ROUND(S.CPU_TIME / 60000000,1) )
                                     ||  ' m'
                                END
                            AS CPU_SECONDS_FORM
                            ,DECODE(L.MAX_CPU_TIME,0,0,S.CPU_TIME / L.MAX_CPU_TIME) AS CPU_SECONDS_PROP
                            ,S.ELAPSED_TIME / 1000000 AS ELAPSED_SECONDS
                                ,CASE WHEN
                                    S.ELAPSED_TIME < 1000
                                THEN
                                    '< 1 ms'
                                WHEN
                                    S.ELAPSED_TIME < 1000000
                                THEN
                                    TO_CHAR(ROUND(S.ELAPSED_TIME / 1000,1) )
                                     ||  ' ms'
                                WHEN
                                    S.ELAPSED_TIME < 60000000
                                THEN
                                    TO_CHAR(ROUND(S.ELAPSED_TIME / 1000000,1) )
                                     ||  ' s'
                                ELSE
                                    TO_CHAR(ROUND(S.ELAPSED_TIME / 60000000,1) )
                                     ||  ' m'
                                END
                            AS ELAPSED_SECONDS_FORM
                            ,DECODE(L.MAX_ELAPSED_TIME,0,0,S.ELAPSED_TIME / L.MAX_ELAPSED_TIME) AS ELAPSED_SECONDS_PROP
                            ,S.DISK_READS AS DISK_READS
                                ,CASE WHEN
                                    S.DISK_READS < 1000
                                THEN
                                    TO_CHAR(S.DISK_READS)
                                WHEN
                                    S.DISK_READS < 1000000
                                THEN
                                    TO_CHAR(ROUND(S.DISK_READS / 1000,1) )
                                     ||  'K'
                                WHEN
                                    S.DISK_READS < 1000000000
                                THEN
                                    TO_CHAR(ROUND(S.DISK_READS / 1000000,1) )
                                     ||  'M'
                                ELSE
                                    TO_CHAR(ROUND(S.DISK_READS / 1000000000,1) )
                                     ||  'G'
                                END
                            AS DISK_READS_FORM
                            ,DECODE(L.MAX_DISK_READS,0,0,S.DISK_READS / L.MAX_DISK_READS) AS DISK_READS_PROP
                            ,S.BUFFER_GETS AS BUFFER_GETS
                                ,CASE WHEN
                                    S.BUFFER_GETS < 1000
                                THEN
                                    TO_CHAR(S.BUFFER_GETS)
                                WHEN
                                    S.BUFFER_GETS < 1000000
                                THEN
                                    TO_CHAR(ROUND(S.BUFFER_GETS / 1000,1) )
                                     ||  'K'
                                WHEN
                                    S.BUFFER_GETS < 1000000000
                                THEN
                                    TO_CHAR(ROUND(S.BUFFER_GETS / 1000000,1) )
                                     ||  'M'
                                ELSE
                                    TO_CHAR(ROUND(S.BUFFER_GETS / 1000000000,1) )
                                     ||  'G'
                                END
                            AS BUFFER_GETS_FORM
                            ,DECODE(L.MAX_BUFFER_GETS,0,0,S.BUFFER_GETS / L.MAX_BUFFER_GETS) AS BUFFER_GETS_PROP
                            ,S.EXECUTIONS AS EXECUTIONS
                                ,CASE WHEN
                                    S.EXECUTIONS < 1000
                                THEN
                                    TO_CHAR(S.EXECUTIONS)
                                WHEN
                                    S.EXECUTIONS < 1000000
                                THEN
                                    TO_CHAR(ROUND(S.EXECUTIONS / 1000,1) )
                                     ||  'K'
                                WHEN
                                    S.EXECUTIONS < 1000000000
                                THEN
                                    TO_CHAR(ROUND(S.EXECUTIONS / 1000000,1) )
                                     ||  'M'
                                ELSE
                                    TO_CHAR(ROUND(S.EXECUTIONS / 1000000000,1) )
                                     ||  'G'
                                END
                            AS EXECUTIONS_FORM
                            ,DECODE(L.MAX_EXECUTIONS,0,0,S.EXECUTIONS / L.MAX_EXECUTIONS) AS EXECUTIONS_PROP
                            ,DECODE(S.MODULE,NULL,' ',S.MODULE) AS MODULE
                            ,S.LAST_ACTIVE_TIME AS LAST_ACTIVE_TIME
                            ,DECODE(S.LAST_ACTIVE_TIME,NULL,' ',TO_CHAR(S.LAST_ACTIVE_TIME,'DD-Mon-YYYY HH24:MI:SS') ) AS LAST_ACTIVE_TIME_FORM
                            ,S.SQL_ID AS SQL_ID
                            ,S.CHILD_NUMBER AS CHILD_NUMBER
                            ,S.INST_ID AS INST_ID
                            ,S.PARSING_SCHEMA_NAME AS PARSING_SCHEMA_NAME
                            ,S.PLAN_HASH_VALUE AS PLAN_HASH_VALUE
                            ,S.OPTIMIZER_COST AS OPTIMIZER_COST
                        FROM
                            GV$SQL S
                            ,(
                                SELECT
                                    MAX(CPU_TIME) AS MAX_CPU_TIME
                                    ,MAX(ELAPSED_TIME) AS MAX_ELAPSED_TIME
                                    ,MAX(DISK_READS) AS MAX_DISK_READS
                                    ,MAX(BUFFER_GETS) AS MAX_BUFFER_GETS
                                    ,MAX(EXECUTIONS) AS MAX_EXECUTIONS
                                FROM
                                    GV$SQL
                            ) L
                    ) D
                ORDER BY
                    CPU_SECONDS_PROP DESC
                    ,SQL
                    ,DISK_READS_PROP
                    ,BUFFER_GETS_PROP
                    ,EXECUTIONS_PROP
                    ,ELAPSED_SECONDS_PROP
                    ,MODULE
                    ,LAST_ACTIVE_TIME
            ) D
    ) D
WHERE ROW# >= 1
AND   ROW# <= 100;

/*
-- Note this section commented out for SQL Developer WEB
--  These settings will work for SQLPlus command line
AND     ROW# <= &n_sql
AND   PARSING_SCHEMA_NAME LIKE '&schema_name';
*/

/* END */
