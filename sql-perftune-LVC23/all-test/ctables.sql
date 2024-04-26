@@connect.sql
set echo on

drop table sales purge;

alter session set NLS_DATE_FORMAT='DD-Mon-YY';

create table sales (
  id number(10)
, sale_date date);

create table sales_lines (
    id number(10),
    line number(10),
    item_desc varchar2(500),
    qty number(10)
  );

insert into sales
select level, sysdate-rownum/1000
from   dual
connect by level <= 500000
/

create index salesi ON sales (sale_date);

insert into sales values (100000, to_date(sysdate+1000));
commit;

declare
   v_num  NUMBER;
   v_qty  NUMBER;
begin
   for r_sales in
     (select id from sales)
     loop
       v_num := DBMS_RANDOM.VALUE(1,20);
       for i in 1..v_num loop
           v_qty := DBMS_RANDOM.VALUE(1,100);
           insert into sales_lines values (r_sales.id, i, 'Item Description ' || i , v_qty);
       end loop;
   end loop;
   commit;

end;
/

create index sales_linesi on sales_lines (id, line);


--
-- Make sure that we don't let histograms help us out here
--
exec dbms_stats.gather_table_stats(user, 'sales', method_opt=>'for all columns size 1')


-- load the staged profile
EXEC DBMS_SQLTUNE.CREATE_STGTAB_SQLPROF ( table_name  => 'sql_prof_stage', schema_name => 'perflab' );
@@stg_SYS_SQLPROF_0184f234f41e0002.sql
COMMIT;

