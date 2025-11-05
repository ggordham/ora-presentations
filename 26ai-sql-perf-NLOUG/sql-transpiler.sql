/* sql-transpler.sql */

SET ECHO ON

CREATE OR REPLACE FUNCTION mnth_abv (date_value DATE) RETURN VARCHAR2 IS
begin
  return to_char ( date_value, 'MON', 'NLS_DATE_LANGUAGE=English' );
end;
/

SELECT employee_id, first_name, last_name 
  FROM employees 
  WHERE mnth_abv ( hire_date ) = 'MAY';

select * 
from  dbms_xplan.display_cursor ( format => 'BASIC +PREDICATE' );

ALTER SESSION SET sql_transpiler = ON;

select employee_id, first_name, last_name 
  from employees 
  where mnth_abv ( hire_date ) = 'MAY';

select * 
from  dbms_xplan.display_cursor ( format => 'BASIC +PREDICATE' );

