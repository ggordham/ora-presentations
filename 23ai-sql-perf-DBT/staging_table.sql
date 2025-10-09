DROP TABLE if exists sales PURGE;

CREATE TABLE SALES 
   ("PROD_ID" NUMBER,
	"CUST_ID" NUMBER,
	"TIME_ID" DATE,
	"CHANNEL_ID" NUMBER,
	"PROMO_ID" NUMBER,
	"QUANTITY_SOLD" NUMBER(10,2),
	"AMOUNT_SOLD" NUMBER(10,2) 
   )
  TABLESPACE "USERS" ;

set timing on
set autotrace on statistics
insert /*+ append */ into sales (select * from sh.sales);
commit;

alter system switch logfile;

column name format a70
column time format a15
set linesize 120
set pagesize 100
SELECT sequence#, name, blocks/1024/1024 AS size_mb,
       to_char(first_time, 'YYMMDD-HH24:MI:SS') as time
  FROM v$archived_log
  WHERE first_time > sysdate -1;


DROP TABLE if exists sales PURGE;

CREATE TABLE SALES 
   ("PROD_ID" NUMBER,
	"CUST_ID" NUMBER,
	"TIME_ID" DATE,
	"CHANNEL_ID" NUMBER,
	"PROMO_ID" NUMBER,
	"QUANTITY_SOLD" NUMBER(10,2),
	"AMOUNT_SOLD" NUMBER(10,2) 
   )
  TABLESPACE "USERS"
  FOR STAGING;


set timing on
set autotrace on statistics
insert /*+ append */ into sales (select * from sh.sales);
commit;

alter system switch logfile;

/*
OWNER        SEGMENT_NAME                   SEGMENT_TYPE     TABLESPACE_NAME            MAX_EXTENTS NO_EXTENTS             SEG_SIZE
------------ ------------------------------ ---------------- ------------------------- ------------ ---------- --------------------
PERFLAB (S)  SALES                          TABLE            USERS                     ############         51           37,748,736
             SALES                          TABLE            USERS                     ############         51           37,748,736
*/
