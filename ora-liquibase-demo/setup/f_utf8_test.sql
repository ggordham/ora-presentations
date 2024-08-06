/*
Test function to see if UTF-8 characters are coming through correctly.
Can test your session by 

select f_utf8_test from dual;

Can test SQLcl liquibase with

liquibase generate-db-objcte -object-name f_utf8_test -object-type function


From Rafal Grzegorczyk
https://rafal.hashnode.dev/configure-liquibase-standalone-oracle-sqlcl-for-usage-with-utf-8-encoding

*/

create or replace function f_utf8_test return varchar2
  as
begin
   return '£ ł ź ć 8 ó ą';
end f_utf8_test;
/

/* end */
