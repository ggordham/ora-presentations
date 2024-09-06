

set serveroutput on size 999999

begin
   dbms_sqldiag.drop_sql_patch('q0_patch', TRUE);
exception
   when others then 
    dbms_output.put_line(sqlerrm);
end;
/



