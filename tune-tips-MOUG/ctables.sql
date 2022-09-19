connect perflab/perf$lab&con_pdb

set echo on
spool ctables.log
--
-- Create two tables with a skewed dataset
--  for explain plan and histogram examples
--
drop table t1 purge;
drop table t2 purge;

create table t1 (a number(10), b varchar2(1000), c number(10), d number(10));


var str VARCHAR2(10)
exec :str := dbms_random.string('u',10);
insert /*+ APPEND */ into t1
select DECODE(parity, 0,rn, 1,rn+1000000), :str, 1, DECODE(parity, 0,rn, 1,10)
from (
    select trunc((rownum+1)/2) as rn, mod(rownum+1,2) as parity
    from (select null from dual connect by level <= 1000)
       , (select null from dual connect by level <= 500)
     );

commit;

create table t2 as select * from t1;

create index t1i on t1 (a);
create index t2i on t2 (a);

--
-- Gather with histograms
--
@@gatherh


-- 
-- Tables for profile example
--
drop table sales purge;

create table sales (
  id number(10)
, sale_date date);

insert into sales
select level, sysdate-rownum/1000
from   dual
connect by level <= 500000
/

create index salesi ON sales (sale_date);

insert into sales values (100000, to_date(sysdate+1000));
commit;

--
-- Make sure that we don't let histograms help us out here
--
exec dbms_stats.gather_table_stats(user, 'sales', method_opt=>'for all columns size 1')

-- 
-- Tables for patch example
--
drop table tab1 purge;
drop table tab2 purge;

create table tab1 (
  id        number(10)
 ,cust      number(10)
 ,num       number(10)
 ,txt       varchar2(100))
/

create table tab2 (
  id        number(10)
 ,ty        varchar2(10)
 ,num       number(10)
 ,txt       varchar2(100))
/

insert into tab1
select rownum,mod(rownum,10),rownum,'Desc'
from   dual connect by rownum < 10000;

insert into tab2
select mod(rownum,100),'T'||rownum,rownum,'Desc'
from   dual connect by rownum < 100;

create unique index tab1pk on tab1 (id);
create unique index tab2pk on tab2 (id);
create index tab2tyi on tab2(ty);

exec dbms_stats.gather_table_stats(user,'tab1');
exec dbms_stats.gather_table_stats(user,'tab2');


-- 
-- Index clustering examples
--
create or replace TYPE cust_address_typ
  AS OBJECT
    ( street_address     VARCHAR2(40)
    , postal_code        VARCHAR2(10)
    , city               VARCHAR2(30)
    , state_province     VARCHAR2(10)
    , country_id         CHAR(2)
    );
/

create or replace TYPE phone_list_typ
  AS VARRAY(5) OF VARCHAR2(25);
/

CREATE TABLE "CUSTOMERS" 
   (	"CUSTOMER_ID" NUMBER(6,0), 
	"CUST_FIRST_NAME" VARCHAR2(20 BYTE) CONSTRAINT "CUST_FNAME_NN" NOT NULL ENABLE, 
	"CUST_LAST_NAME" VARCHAR2(20 BYTE) CONSTRAINT "CUST_LNAME_NN" NOT NULL ENABLE, 
	"CUST_ADDRESS" "CUST_ADDRESS_TYP" , 
	"PHONE_NUMBERS" "PHONE_LIST_TYP" , 
	"NLS_LANGUAGE" VARCHAR2(3 BYTE), 
	"NLS_TERRITORY" VARCHAR2(30 BYTE), 
	"CREDIT_LIMIT" NUMBER(9,2), 
	"CUST_EMAIL" VARCHAR2(40 BYTE), 
	"ACCOUNT_MGR_ID" NUMBER(6,0), 
	"CUST_GEO_LOCATION" "MDSYS"."SDO_GEOMETRY" , 
	"DATE_OF_BIRTH" DATE, 
	"MARITAL_STATUS" VARCHAR2(20 BYTE), 
	"GENDER" VARCHAR2(1 BYTE), 
	"INCOME_LEVEL" VARCHAR2(20 BYTE), 
	 CONSTRAINT "CUSTOMER_CREDIT_LIMIT_MAX" CHECK (credit_limit <= 5000) ENABLE, 
	 CONSTRAINT "CUSTOMER_ID_MIN" CHECK (customer_id > 0) ENABLE 
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
 VARRAY "CUST_GEO_LOCATION"."SDO_ELEM_INFO" STORE AS SECUREFILE LOB 
  ( TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192
  CACHE  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
 VARRAY "CUST_GEO_LOCATION"."SDO_ORDINATES" STORE AS SECUREFILE LOB 
  ( TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192
  CACHE  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;

CREATE UNIQUE INDEX "CUSTOMERS_PK" ON "CUSTOMERS" ("CUSTOMER_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

ALTER TABLE "CUSTOMERS" ADD CONSTRAINT "CUSTOMERS_PK" PRIMARY KEY ("CUSTOMER_ID")
  USING INDEX "CUSTOMERS_PK"  ENABLE;


CREATE INDEX "CUST_ACCOUNT_MANAGER_IX" ON "CUSTOMERS" ("ACCOUNT_MGR_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

CREATE INDEX "CUST_EMAIL_IX" ON "CUSTOMERS" ("CUST_EMAIL") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

CREATE INDEX "CUST_LNAME_IX" ON "CUSTOMERS" ("CUST_LAST_NAME") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

CREATE INDEX "CUST_UPPER_NAME_IX" ON "CUSTOMERS" (UPPER("CUST_LAST_NAME"), UPPER("CUST_FIRST_NAME")) 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;

@customer-data.sql

exec dbms_stats.gather_table_stats(user,'CUSTOMERS');

-- Drop any SQL plan baselines
@@drop-baselines
spool off
