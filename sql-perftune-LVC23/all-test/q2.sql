select /* ALLTEST */ /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */ s.id, MAX(l.qty) max_qty from sales s, sales_lines l WHERE s.id = l.id and s.sale_date >= trunc(sysdate) group by s.id;
