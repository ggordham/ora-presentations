SET ECHO ON

select /* PROFTEST */ COUNT(*) from sales WHERE sale_date >= trunc(sysdate);
