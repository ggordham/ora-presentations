/* profile-q1.sql */

SET ECHO ON

SELECT /* PROFTEST */ /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */ COUNT(1) FROM sales WHERE sale_date >= trunc(sysdate);

SET ECHO OFF
