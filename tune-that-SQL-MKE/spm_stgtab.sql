@connect.sql

--------------------------------------------------------
--  DDL for Table SPM_STGTAB
--------------------------------------------------------

  CREATE TABLE "PERFLAB"."SPM_STGTAB" 
   (	"VERSION" NUMBER, 
	"SIGNATURE" NUMBER, 
	"SQL_HANDLE" VARCHAR2(30 BYTE), 
	"OBJ_NAME" VARCHAR2(128 BYTE), 
	"OBJ_TYPE" VARCHAR2(30 BYTE), 
	"PLAN_ID" NUMBER, 
	"SQL_TEXT" CLOB, 
	"CREATOR" VARCHAR2(128 BYTE), 
	"ORIGIN" VARCHAR2(30 BYTE), 
	"DESCRIPTION" VARCHAR2(500 BYTE), 
	"DB_VERSION" VARCHAR2(64 BYTE), 
	"CREATED" TIMESTAMP (6), 
	"LAST_MODIFIED" TIMESTAMP (6), 
	"LAST_EXECUTED" TIMESTAMP (6), 
	"LAST_VERIFIED" TIMESTAMP (6), 
	"STATUS" NUMBER, 
	"OPTIMIZER_COST" NUMBER, 
	"MODULE" VARCHAR2(64 BYTE), 
	"ACTION" VARCHAR2(64 BYTE), 
	"EXECUTIONS" NUMBER, 
	"ELAPSED_TIME" NUMBER, 
	"CPU_TIME" NUMBER, 
	"BUFFER_GETS" NUMBER, 
	"DISK_READS" NUMBER, 
	"DIRECT_WRITES" NUMBER, 
	"ROWS_PROCESSED" NUMBER, 
	"FETCHES" NUMBER, 
	"END_OF_FETCH_COUNT" NUMBER, 
	"CATEGORY" VARCHAR2(128 BYTE), 
	"SQLFLAGS" NUMBER, 
	"TASK_ID" NUMBER, 
	"TASK_EXEC_NAME" VARCHAR2(128 BYTE), 
	"TASK_OBJ_ID" NUMBER, 
	"TASK_FND_ID" NUMBER, 
	"TASK_REC_ID" NUMBER, 
	"INUSE_FEATURES" NUMBER, 
	"PARSE_CPU_TIME" NUMBER, 
	"PRIORITY" NUMBER, 
	"OPTIMIZER_ENV" RAW(2000), 
	"BIND_DATA" RAW(2000), 
	"PARSING_SCHEMA_NAME" VARCHAR2(128 BYTE), 
	"COMP_DATA" CLOB, 
	"STATEMENT_ID" VARCHAR2(30 BYTE), 
	"XPL_PLAN_ID" NUMBER, 
	"TIMESTAMP" DATE, 
	"REMARKS" VARCHAR2(4000 BYTE), 
	"OPERATION" VARCHAR2(30 BYTE), 
	"OPTIONS" VARCHAR2(255 BYTE), 
	"OBJECT_NODE" VARCHAR2(128 BYTE), 
	"OBJECT_OWNER" VARCHAR2(128 BYTE), 
	"OBJECT_NAME" VARCHAR2(128 BYTE), 
	"OBJECT_ALIAS" VARCHAR2(261 BYTE), 
	"OBJECT_INSTANCE" NUMBER, 
	"OBJECT_TYPE" VARCHAR2(30 BYTE), 
	"OPTIMIZER" VARCHAR2(255 BYTE), 
	"SEARCH_COLUMNS" NUMBER, 
	"ID" NUMBER, 
	"PARENT_ID" NUMBER, 
	"DEPTH" NUMBER, 
	"POSITION" NUMBER, 
	"COST" NUMBER, 
	"CARDINALITY" NUMBER, 
	"BYTES" NUMBER, 
	"OTHER_TAG" VARCHAR2(255 BYTE), 
	"PARTITION_START" VARCHAR2(255 BYTE), 
	"PARTITION_STOP" VARCHAR2(255 BYTE), 
	"PARTITION_ID" NUMBER, 
	"DISTRIBUTION" VARCHAR2(30 BYTE), 
	"CPU_COST" NUMBER(38,0), 
	"IO_COST" NUMBER(38,0), 
	"TEMP_SPACE" NUMBER(38,0), 
	"ACCESS_PREDICATES" VARCHAR2(4000 BYTE), 
	"FILTER_PREDICATES" VARCHAR2(4000 BYTE), 
	"PROJECTION" VARCHAR2(4000 BYTE), 
	"TIME" NUMBER(38,0), 
	"QBLOCK_NAME" VARCHAR2(128 BYTE), 
	"OTHER_XML" CLOB
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
 LOB ("SQL_TEXT") STORE AS SECUREFILE (
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
 LOB ("COMP_DATA") STORE AS SECUREFILE (
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) 
 LOB ("OTHER_XML") STORE AS SECUREFILE (
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192
  NOCACHE LOGGING  NOCOMPRESS  KEEP_DUPLICATES 
  STORAGE(INITIAL 106496 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;
REM INSERTING into PERFLAB.SPM_STGTAB
SET DEFINE OFF;
Insert into PERFLAB.SPM_STGTAB (VERSION,SIGNATURE,SQL_HANDLE,OBJ_NAME,OBJ_TYPE,PLAN_ID,CREATOR,ORIGIN,DESCRIPTION,DB_VERSION,CREATED,LAST_MODIFIED,LAST_EXECUTED,LAST_VERIFIED,STATUS,OPTIMIZER_COST,MODULE,ACTION,EXECUTIONS,ELAPSED_TIME,CPU_TIME,BUFFER_GETS,DISK_READS,DIRECT_WRITES,ROWS_PROCESSED,FETCHES,END_OF_FETCH_COUNT,CATEGORY,SQLFLAGS,TASK_ID,TASK_EXEC_NAME,TASK_OBJ_ID,TASK_FND_ID,TASK_REC_ID,INUSE_FEATURES,PARSE_CPU_TIME,PRIORITY,OPTIMIZER_ENV,BIND_DATA,PARSING_SCHEMA_NAME,STATEMENT_ID,XPL_PLAN_ID,TIMESTAMP,REMARKS,OPERATION,OPTIONS,OBJECT_NODE,OBJECT_OWNER,OBJECT_NAME,OBJECT_ALIAS,OBJECT_INSTANCE,OBJECT_TYPE,OPTIMIZER,SEARCH_COLUMNS,ID,PARENT_ID,DEPTH,POSITION,COST,CARDINALITY,BYTES,OTHER_TAG,PARTITION_START,PARTITION_STOP,PARTITION_ID,DISTRIBUTION,CPU_COST,IO_COST,TEMP_SPACE,ACCESS_PREDICATES,FILTER_PREDICATES,PROJECTION,TIME,QBLOCK_NAME) values (4,4022507629801686773,'SQL_37d2d1608ca0c6f5','SQL_PLAN_3gnqjc26a1jrpceb2ac1e','SQL_PLAN_BASELINE',3467815966,'PERFLAB','AUTO-CAPTURE',null,'19.0.0.0.0',to_timestamp('17-OCT-23 06.37.22.248764000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),null,139,551,'SQL*Plus',null,0,0,0,0,0,0,0,0,null,'DEFAULT',0,null,null,null,null,null,1,null,0,'E289FB89D011220170021000AEF5C3E2CFFA331056414555519521105545551545545558591555449665851D5511058555555155515122555415A0EA0C5551454265455454549081566E001696C6A355451501025415504416FD557151551555551001550A16214545D1C35444A1011015595510250153355555555551E91F1411855B0501655D56456144551525245005F9A4160190505165551695504415957945000544005AD01122010502000002000000100000000100002000000208D007000000FC0B00002003000101000038F8110300000090010000FE0500D01122016564640202643202320000020003020A0A05050A1400020000F4010000640A0A0A0A64E803000064C080030200020000FFFF00000202324000400000E803000010270000002000000A1E03C80000080000010000102700000304810A80969800E80300004B64FFFF0000FFFF00000010000014A08601006440204E00000702C8C823F8FF0000FFFF00000204400A1450320A0A00001000','BEDA13000000652ED461000101C0021602C20B','PERFLAB',null,null,to_date('17-OCT-23','DD-MON-RR'),null,'NESTED LOOPS',null,null,null,null,null,null,null,null,null,3,2,3,1,551,1,22,null,null,null,null,null,144343820,549,null,null,null,'(#keys=0) "T1"."C"[NUMBER,22], "T2".ROWID[ROWID,10]',1,null);
Insert into PERFLAB.SPM_STGTAB (VERSION,SIGNATURE,SQL_HANDLE,OBJ_NAME,OBJ_TYPE,PLAN_ID,CREATOR,ORIGIN,DESCRIPTION,DB_VERSION,CREATED,LAST_MODIFIED,LAST_EXECUTED,LAST_VERIFIED,STATUS,OPTIMIZER_COST,MODULE,ACTION,EXECUTIONS,ELAPSED_TIME,CPU_TIME,BUFFER_GETS,DISK_READS,DIRECT_WRITES,ROWS_PROCESSED,FETCHES,END_OF_FETCH_COUNT,CATEGORY,SQLFLAGS,TASK_ID,TASK_EXEC_NAME,TASK_OBJ_ID,TASK_FND_ID,TASK_REC_ID,INUSE_FEATURES,PARSE_CPU_TIME,PRIORITY,OPTIMIZER_ENV,BIND_DATA,PARSING_SCHEMA_NAME,STATEMENT_ID,XPL_PLAN_ID,TIMESTAMP,REMARKS,OPERATION,OPTIONS,OBJECT_NODE,OBJECT_OWNER,OBJECT_NAME,OBJECT_ALIAS,OBJECT_INSTANCE,OBJECT_TYPE,OPTIMIZER,SEARCH_COLUMNS,ID,PARENT_ID,DEPTH,POSITION,COST,CARDINALITY,BYTES,OTHER_TAG,PARTITION_START,PARTITION_STOP,PARTITION_ID,DISTRIBUTION,CPU_COST,IO_COST,TEMP_SPACE,ACCESS_PREDICATES,FILTER_PREDICATES,PROJECTION,TIME,QBLOCK_NAME) values (4,4022507629801686773,'SQL_37d2d1608ca0c6f5','SQL_PLAN_3gnqjc26a1jrpceb2ac1e','SQL_PLAN_BASELINE',3467815966,'PERFLAB','AUTO-CAPTURE',null,'19.0.0.0.0',to_timestamp('17-OCT-23 06.37.22.248764000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),null,139,551,'SQL*Plus',null,0,0,0,0,0,0,0,0,null,'DEFAULT',0,null,null,null,null,null,1,null,0,'E289FB89D011220170021000AEF5C3E2CFFA331056414555519521105545551545545558591555449665851D5511058555555155515122555415A0EA0C5551454265455454549081566E001696C6A355451501025415504416FD557151551555551001550A16214545D1C35444A1011015595510250153355555555551E91F1411855B0501655D56456144551525245005F9A4160190505165551695504415957945000544005AD01122010502000002000000100000000100002000000208D007000000FC0B00002003000101000038F8110300000090010000FE0500D01122016564640202643202320000020003020A0A05050A1400020000F4010000640A0A0A0A64E803000064C080030200020000FFFF00000202324000400000E803000010270000002000000A1E03C80000080000010000102700000304810A80969800E80300004B64FFFF0000FFFF00000010000014A08601006440204E00000702C8C823F8FF0000FFFF00000204400A1450320A0A00001000','BEDA13000000652ED461000101C0021602C20B','PERFLAB',null,null,to_date('17-OCT-23','DD-MON-RR'),null,'TABLE ACCESS','FULL',null,'PERFLAB','T1','"T1"@"SEL$1"',1,'TABLE','ANALYZED',null,4,3,4,1,548,1,13,null,null,null,null,null,144321216,546,null,null,'"T1"."D"=:IDNUM','"T1"."A"[NUMBER,22], "T1"."C"[NUMBER,22]',1,'SEL$1');
Insert into PERFLAB.SPM_STGTAB (VERSION,SIGNATURE,SQL_HANDLE,OBJ_NAME,OBJ_TYPE,PLAN_ID,CREATOR,ORIGIN,DESCRIPTION,DB_VERSION,CREATED,LAST_MODIFIED,LAST_EXECUTED,LAST_VERIFIED,STATUS,OPTIMIZER_COST,MODULE,ACTION,EXECUTIONS,ELAPSED_TIME,CPU_TIME,BUFFER_GETS,DISK_READS,DIRECT_WRITES,ROWS_PROCESSED,FETCHES,END_OF_FETCH_COUNT,CATEGORY,SQLFLAGS,TASK_ID,TASK_EXEC_NAME,TASK_OBJ_ID,TASK_FND_ID,TASK_REC_ID,INUSE_FEATURES,PARSE_CPU_TIME,PRIORITY,OPTIMIZER_ENV,BIND_DATA,PARSING_SCHEMA_NAME,STATEMENT_ID,XPL_PLAN_ID,TIMESTAMP,REMARKS,OPERATION,OPTIONS,OBJECT_NODE,OBJECT_OWNER,OBJECT_NAME,OBJECT_ALIAS,OBJECT_INSTANCE,OBJECT_TYPE,OPTIMIZER,SEARCH_COLUMNS,ID,PARENT_ID,DEPTH,POSITION,COST,CARDINALITY,BYTES,OTHER_TAG,PARTITION_START,PARTITION_STOP,PARTITION_ID,DISTRIBUTION,CPU_COST,IO_COST,TEMP_SPACE,ACCESS_PREDICATES,FILTER_PREDICATES,PROJECTION,TIME,QBLOCK_NAME) values (4,4022507629801686773,'SQL_37d2d1608ca0c6f5','SQL_PLAN_3gnqjc26a1jrpceb2ac1e','SQL_PLAN_BASELINE',3467815966,'PERFLAB','AUTO-CAPTURE',null,'19.0.0.0.0',to_timestamp('17-OCT-23 06.37.22.248764000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),null,139,551,'SQL*Plus',null,0,0,0,0,0,0,0,0,null,'DEFAULT',0,null,null,null,null,null,1,null,0,'E289FB89D011220170021000AEF5C3E2CFFA331056414555519521105545551545545558591555449665851D5511058555555155515122555415A0EA0C5551454265455454549081566E001696C6A355451501025415504416FD557151551555551001550A16214545D1C35444A1011015595510250153355555555551E91F1411855B0501655D56456144551525245005F9A4160190505165551695504415957945000544005AD01122010502000002000000100000000100002000000208D007000000FC0B00002003000101000038F8110300000090010000FE0500D01122016564640202643202320000020003020A0A05050A1400020000F4010000640A0A0A0A64E803000064C080030200020000FFFF00000202324000400000E803000010270000002000000A1E03C80000080000010000102700000304810A80969800E80300004B64FFFF0000FFFF00000010000014A08601006440204E00000702C8C823F8FF0000FFFF00000204400A1450320A0A00001000','BEDA13000000652ED461000101C0021602C20B','PERFLAB',null,null,to_date('17-OCT-23','DD-MON-RR'),null,'INDEX','RANGE SCAN',null,'PERFLAB','T2I','"T2"@"SEL$1"',null,'INDEX','ANALYZED',1,5,3,4,2,2,1,null,null,null,null,null,null,15293,2,null,'"T1"."A"="T2"."A"',null,'"T2".ROWID[ROWID,10]',1,'SEL$1');
Insert into PERFLAB.SPM_STGTAB (VERSION,SIGNATURE,SQL_HANDLE,OBJ_NAME,OBJ_TYPE,PLAN_ID,CREATOR,ORIGIN,DESCRIPTION,DB_VERSION,CREATED,LAST_MODIFIED,LAST_EXECUTED,LAST_VERIFIED,STATUS,OPTIMIZER_COST,MODULE,ACTION,EXECUTIONS,ELAPSED_TIME,CPU_TIME,BUFFER_GETS,DISK_READS,DIRECT_WRITES,ROWS_PROCESSED,FETCHES,END_OF_FETCH_COUNT,CATEGORY,SQLFLAGS,TASK_ID,TASK_EXEC_NAME,TASK_OBJ_ID,TASK_FND_ID,TASK_REC_ID,INUSE_FEATURES,PARSE_CPU_TIME,PRIORITY,OPTIMIZER_ENV,BIND_DATA,PARSING_SCHEMA_NAME,STATEMENT_ID,XPL_PLAN_ID,TIMESTAMP,REMARKS,OPERATION,OPTIONS,OBJECT_NODE,OBJECT_OWNER,OBJECT_NAME,OBJECT_ALIAS,OBJECT_INSTANCE,OBJECT_TYPE,OPTIMIZER,SEARCH_COLUMNS,ID,PARENT_ID,DEPTH,POSITION,COST,CARDINALITY,BYTES,OTHER_TAG,PARTITION_START,PARTITION_STOP,PARTITION_ID,DISTRIBUTION,CPU_COST,IO_COST,TEMP_SPACE,ACCESS_PREDICATES,FILTER_PREDICATES,PROJECTION,TIME,QBLOCK_NAME) values (4,4022507629801686773,'SQL_37d2d1608ca0c6f5','SQL_PLAN_3gnqjc26a1jrpceb2ac1e','SQL_PLAN_BASELINE',3467815966,'PERFLAB','AUTO-CAPTURE',null,'19.0.0.0.0',to_timestamp('17-OCT-23 06.37.22.248764000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),null,139,551,'SQL*Plus',null,0,0,0,0,0,0,0,0,null,'DEFAULT',0,null,null,null,null,null,1,null,0,'E289FB89D011220170021000AEF5C3E2CFFA331056414555519521105545551545545558591555449665851D5511058555555155515122555415A0EA0C5551454265455454549081566E001696C6A355451501025415504416FD557151551555551001550A16214545D1C35444A1011015595510250153355555555551E91F1411855B0501655D56456144551525245005F9A4160190505165551695504415957945000544005AD01122010502000002000000100000000100002000000208D007000000FC0B00002003000101000038F8110300000090010000FE0500D01122016564640202643202320000020003020A0A05050A1400020000F4010000640A0A0A0A64E803000064C080030200020000FFFF00000202324000400000E803000010270000002000000A1E03C80000080000010000102700000304810A80969800E80300004B64FFFF0000FFFF00000010000014A08601006440204E00000702C8C823F8FF0000FFFF00000204400A1450320A0A00001000','BEDA13000000652ED461000101C0021602C20B','PERFLAB',null,null,to_date('17-OCT-23','DD-MON-RR'),null,'TABLE ACCESS','BY INDEX ROWID',null,'PERFLAB','T2','"T2"@"SEL$1"',2,'TABLE','ANALYZED',null,6,2,3,2,3,1,9,null,null,null,null,null,22604,3,null,null,null,'"T2"."C"[NUMBER,22]',1,'SEL$1');
Insert into PERFLAB.SPM_STGTAB (VERSION,SIGNATURE,SQL_HANDLE,OBJ_NAME,OBJ_TYPE,PLAN_ID,CREATOR,ORIGIN,DESCRIPTION,DB_VERSION,CREATED,LAST_MODIFIED,LAST_EXECUTED,LAST_VERIFIED,STATUS,OPTIMIZER_COST,MODULE,ACTION,EXECUTIONS,ELAPSED_TIME,CPU_TIME,BUFFER_GETS,DISK_READS,DIRECT_WRITES,ROWS_PROCESSED,FETCHES,END_OF_FETCH_COUNT,CATEGORY,SQLFLAGS,TASK_ID,TASK_EXEC_NAME,TASK_OBJ_ID,TASK_FND_ID,TASK_REC_ID,INUSE_FEATURES,PARSE_CPU_TIME,PRIORITY,OPTIMIZER_ENV,BIND_DATA,PARSING_SCHEMA_NAME,STATEMENT_ID,XPL_PLAN_ID,TIMESTAMP,REMARKS,OPERATION,OPTIONS,OBJECT_NODE,OBJECT_OWNER,OBJECT_NAME,OBJECT_ALIAS,OBJECT_INSTANCE,OBJECT_TYPE,OPTIMIZER,SEARCH_COLUMNS,ID,PARENT_ID,DEPTH,POSITION,COST,CARDINALITY,BYTES,OTHER_TAG,PARTITION_START,PARTITION_STOP,PARTITION_ID,DISTRIBUTION,CPU_COST,IO_COST,TEMP_SPACE,ACCESS_PREDICATES,FILTER_PREDICATES,PROJECTION,TIME,QBLOCK_NAME) values (4,4022507629801686773,'SQL_37d2d1608ca0c6f5','SQL_PLAN_3gnqjc26a1jrpceb2ac1e','SQL_PLAN_BASELINE',3467815966,'PERFLAB','AUTO-CAPTURE',null,'19.0.0.0.0',to_timestamp('17-OCT-23 06.37.22.248764000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),null,139,551,'SQL*Plus',null,0,0,0,0,0,0,0,0,null,'DEFAULT',0,null,null,null,null,null,1,null,0,'E289FB89D011220170021000AEF5C3E2CFFA331056414555519521105545551545545558591555449665851D5511058555555155515122555415A0EA0C5551454265455454549081566E001696C6A355451501025415504416FD557151551555551001550A16214545D1C35444A1011015595510250153355555555551E91F1411855B0501655D56456144551525245005F9A4160190505165551695504415957945000544005AD01122010502000002000000100000000100002000000208D007000000FC0B00002003000101000038F8110300000090010000FE0500D01122016564640202643202320000020003020A0A05050A1400020000F4010000640A0A0A0A64E803000064C080030200020000FFFF00000202324000400000E803000010270000002000000A1E03C80000080000010000102700000304810A80969800E80300004B64FFFF0000FFFF00000010000014A08601006440204E00000702C8C823F8FF0000FFFF00000204400A1450320A0A00001000','BEDA13000000652ED461000101C0021602C20B','PERFLAB',null,null,to_date('17-OCT-23','DD-MON-RR'),null,'SELECT STATEMENT',null,null,null,null,null,null,null,'ALL_ROWS',null,0,null,0,551,551,1,22,null,null,null,null,null,144343820,549,null,null,null,null,1,null);
Insert into PERFLAB.SPM_STGTAB (VERSION,SIGNATURE,SQL_HANDLE,OBJ_NAME,OBJ_TYPE,PLAN_ID,CREATOR,ORIGIN,DESCRIPTION,DB_VERSION,CREATED,LAST_MODIFIED,LAST_EXECUTED,LAST_VERIFIED,STATUS,OPTIMIZER_COST,MODULE,ACTION,EXECUTIONS,ELAPSED_TIME,CPU_TIME,BUFFER_GETS,DISK_READS,DIRECT_WRITES,ROWS_PROCESSED,FETCHES,END_OF_FETCH_COUNT,CATEGORY,SQLFLAGS,TASK_ID,TASK_EXEC_NAME,TASK_OBJ_ID,TASK_FND_ID,TASK_REC_ID,INUSE_FEATURES,PARSE_CPU_TIME,PRIORITY,OPTIMIZER_ENV,BIND_DATA,PARSING_SCHEMA_NAME,STATEMENT_ID,XPL_PLAN_ID,TIMESTAMP,REMARKS,OPERATION,OPTIONS,OBJECT_NODE,OBJECT_OWNER,OBJECT_NAME,OBJECT_ALIAS,OBJECT_INSTANCE,OBJECT_TYPE,OPTIMIZER,SEARCH_COLUMNS,ID,PARENT_ID,DEPTH,POSITION,COST,CARDINALITY,BYTES,OTHER_TAG,PARTITION_START,PARTITION_STOP,PARTITION_ID,DISTRIBUTION,CPU_COST,IO_COST,TEMP_SPACE,ACCESS_PREDICATES,FILTER_PREDICATES,PROJECTION,TIME,QBLOCK_NAME) values (4,4022507629801686773,'SQL_37d2d1608ca0c6f5','SQL_PLAN_3gnqjc26a1jrpceb2ac1e','SQL_PLAN_BASELINE',3467815966,'PERFLAB','AUTO-CAPTURE',null,'19.0.0.0.0',to_timestamp('17-OCT-23 06.37.22.248764000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),null,139,551,'SQL*Plus',null,0,0,0,0,0,0,0,0,null,'DEFAULT',0,null,null,null,null,null,1,null,0,'E289FB89D011220170021000AEF5C3E2CFFA331056414555519521105545551545545558591555449665851D5511058555555155515122555415A0EA0C5551454265455454549081566E001696C6A355451501025415504416FD557151551555551001550A16214545D1C35444A1011015595510250153355555555551E91F1411855B0501655D56456144551525245005F9A4160190505165551695504415957945000544005AD01122010502000002000000100000000100002000000208D007000000FC0B00002003000101000038F8110300000090010000FE0500D01122016564640202643202320000020003020A0A05050A1400020000F4010000640A0A0A0A64E803000064C080030200020000FFFF00000202324000400000E803000010270000002000000A1E03C80000080000010000102700000304810A80969800E80300004B64FFFF0000FFFF00000010000014A08601006440204E00000702C8C823F8FF0000FFFF00000204400A1450320A0A00001000','BEDA13000000652ED461000101C0021602C20B','PERFLAB',null,null,to_date('17-OCT-23','DD-MON-RR'),null,'SORT','AGGREGATE',null,null,null,null,null,null,null,null,1,0,1,1,null,1,22,null,null,null,null,null,null,null,null,null,null,'(#keys=0) SUM("T2"."C")[22], SUM("T1"."C")[22]',null,'SEL$1');
Insert into PERFLAB.SPM_STGTAB (VERSION,SIGNATURE,SQL_HANDLE,OBJ_NAME,OBJ_TYPE,PLAN_ID,CREATOR,ORIGIN,DESCRIPTION,DB_VERSION,CREATED,LAST_MODIFIED,LAST_EXECUTED,LAST_VERIFIED,STATUS,OPTIMIZER_COST,MODULE,ACTION,EXECUTIONS,ELAPSED_TIME,CPU_TIME,BUFFER_GETS,DISK_READS,DIRECT_WRITES,ROWS_PROCESSED,FETCHES,END_OF_FETCH_COUNT,CATEGORY,SQLFLAGS,TASK_ID,TASK_EXEC_NAME,TASK_OBJ_ID,TASK_FND_ID,TASK_REC_ID,INUSE_FEATURES,PARSE_CPU_TIME,PRIORITY,OPTIMIZER_ENV,BIND_DATA,PARSING_SCHEMA_NAME,STATEMENT_ID,XPL_PLAN_ID,TIMESTAMP,REMARKS,OPERATION,OPTIONS,OBJECT_NODE,OBJECT_OWNER,OBJECT_NAME,OBJECT_ALIAS,OBJECT_INSTANCE,OBJECT_TYPE,OPTIMIZER,SEARCH_COLUMNS,ID,PARENT_ID,DEPTH,POSITION,COST,CARDINALITY,BYTES,OTHER_TAG,PARTITION_START,PARTITION_STOP,PARTITION_ID,DISTRIBUTION,CPU_COST,IO_COST,TEMP_SPACE,ACCESS_PREDICATES,FILTER_PREDICATES,PROJECTION,TIME,QBLOCK_NAME) values (4,4022507629801686773,'SQL_37d2d1608ca0c6f5','SQL_PLAN_3gnqjc26a1jrpceb2ac1e','SQL_PLAN_BASELINE',3467815966,'PERFLAB','AUTO-CAPTURE',null,'19.0.0.0.0',to_timestamp('17-OCT-23 06.37.22.248764000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),to_timestamp('17-OCT-23 06.37.22.000000000 PM','DD-MON-RR HH.MI.SSXFF AM'),null,139,551,'SQL*Plus',null,0,0,0,0,0,0,0,0,null,'DEFAULT',0,null,null,null,null,null,1,null,0,'E289FB89D011220170021000AEF5C3E2CFFA331056414555519521105545551545545558591555449665851D5511058555555155515122555415A0EA0C5551454265455454549081566E001696C6A355451501025415504416FD557151551555551001550A16214545D1C35444A1011015595510250153355555555551E91F1411855B0501655D56456144551525245005F9A4160190505165551695504415957945000544005AD01122010502000002000000100000000100002000000208D007000000FC0B00002003000101000038F8110300000090010000FE0500D01122016564640202643202320000020003020A0A05050A1400020000F4010000640A0A0A0A64E803000064C080030200020000FFFF00000202324000400000E803000010270000002000000A1E03C80000080000010000102700000304810A80969800E80300004B64FFFF0000FFFF00000010000014A08601006440204E00000702C8C823F8FF0000FFFF00000204400A1450320A0A00001000','BEDA13000000652ED461000101C0021602C20B','PERFLAB',null,null,to_date('17-OCT-23','DD-MON-RR'),null,'NESTED LOOPS',null,null,null,null,null,null,null,null,null,2,1,2,1,551,1,22,null,null,null,null,null,144343820,549,null,null,null,'(#keys=0) "T1"."C"[NUMBER,22], "T2"."C"[NUMBER,22]',1,null);

COMMIT;

