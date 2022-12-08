select /* PROFTEST */ /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */ COUNT(*) from sales WHERE sale_date >= trunc(sysdate);
