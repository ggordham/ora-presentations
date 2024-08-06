
  ALTER TABLE "HR_TST"."EMPLOYEES" ADD CONSTRAINT "EMP_MANAGER_FK" FOREIGN KEY ("MANAGER_ID")
	  REFERENCES "HR_TST"."EMPLOYEES" ("EMPLOYEE_ID") ENABLE;
  ALTER TABLE "HR_TST"."EMPLOYEES" ADD CONSTRAINT "EMP_DEPT_FK" FOREIGN KEY ("DEPARTMENT_ID")
	  REFERENCES "HR_TST"."DEPARTMENTS" ("DEPARTMENT_ID") ENABLE;
  ALTER TABLE "HR_TST"."EMPLOYEES" ADD CONSTRAINT "EMP_JOB_FK" FOREIGN KEY ("JOB_ID")
	  REFERENCES "HR_TST"."JOBS" ("JOB_ID") ENABLE;