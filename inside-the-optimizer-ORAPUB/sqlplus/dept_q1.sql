SELECT /*+ parallel(4) full(e) full(d) gather_plan_statistics */ 
       department_name, sum(salary)
   FROM hr.employees e, hr.departments d
  WHERE d.department_id=e.department_id
  GROUP BY department_name;
