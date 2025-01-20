
   COMMENT ON TABLE "JOBS"  IS 'jobs table with job titles and salary ranges. Contains 19 rows.
References with employees and job_history table.';
   COMMENT ON COLUMN "JOBS"."JOB_ID" IS 'Primary key of jobs table.';
   COMMENT ON COLUMN "JOBS"."JOB_TITLE" IS 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';
   COMMENT ON COLUMN "JOBS"."MIN_SALARY" IS 'Minimum salary for a job title.';
   COMMENT ON COLUMN "JOBS"."MAX_SALARY" IS 'Maximum salary for a job title';