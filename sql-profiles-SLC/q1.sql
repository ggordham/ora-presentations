SELECT /* PROFTEST */ /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */ COUNT(1) FROM sales WHERE sale_date >= trunc(sysdate);
