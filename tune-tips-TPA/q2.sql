
/* 
  Sample query to test data for skew
  select trunc(sale_date, 'DD'), count(1) from sales group by trunc(sale_date, 'DD') order by 1 asc;
*/

SET ECHO ON

select /* PROFTEST */ COUNT(*) from sales WHERE sale_date >= trunc(sysdate);


