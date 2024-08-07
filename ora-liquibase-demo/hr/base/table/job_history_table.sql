  CREATE TABLE "HR_TST"."JOB_HISTORY" 
   (	"EMPLOYEE_ID" NUMBER(6,0) CONSTRAINT "JHIST_EMPLOYEE_NN" NOT NULL ENABLE,
	"START_DATE" DATE CONSTRAINT "JHIST_START_DATE_NN" NOT NULL ENABLE,
	"END_DATE" DATE CONSTRAINT "JHIST_END_DATE_NN" NOT NULL ENABLE,
	"JOB_ID" VARCHAR2(10) CONSTRAINT "JHIST_JOB_NN" NOT NULL ENABLE,
	"DEPARTMENT_ID" NUMBER(4,0),
	CONSTRAINT "JHIST_DATE_INTERVAL" CHECK (end_date > start_date) ENABLE,
	CONSTRAINT "JHIST_EMP_ID_ST_DATE_PK" PRIMARY KEY ("EMPLOYEE_ID","START_DATE")
  USING INDEX
  PCTFREE 10 INITRANS 2 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE,
	CONSTRAINT "JHIST_JOB_FK" FOREIGN KEY ("JOB_ID")
	 REFERENCES "HR_TST"."JOBS" ("JOB_ID") ENABLE,
	CONSTRAINT "JHIST_DEPT_FK" FOREIGN KEY ("DEPARTMENT_ID")
	 REFERENCES "HR_TST"."DEPARTMENTS" ("DEPARTMENT_ID") ENABLE,
	CONSTRAINT "JHIST_EMP_FK" FOREIGN KEY ("EMPLOYEE_ID")
	 REFERENCES "HR_TST"."EMPLOYEES" ("EMPLOYEE_ID") ENABLE
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 NOCOMPRESS LOGGING
  STORAGE( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"