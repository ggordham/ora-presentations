/* ash_report.sql */

declare
dbid number;
instance_id number;
begin
select dbid into dbid from v$database;
select instance_number into instance_id from v$instance;
dbms_output.enable(500000);
dbms_output.put_line('<PRE>');
for rc in ( select output from 
   table(dbms_workload_repository.ash_report_text( dbid,instance_id,SYSDATE-31/1440, SYSDATE-1/1440))) loop
   dbms_output.put_line(rc.output);
end loop;
dbms_output.put_line('</PRE>') ;
end;
