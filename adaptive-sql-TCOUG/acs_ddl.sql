set verify off

var g1 varchar2(100)
var g2 varchar2(100)
var g3 varchar2(100)
begin
    :g1 := '&1';
    :g2 := '&2';
    :g3 := '&3';
    dbms_output.put_line(:g1);
    dbms_output.put_line(:g2);
    dbms_output.put_line(:g3);
end;
/


drop table if exists acs_test;

create table if not exists  acs_test 
                  (id number GENERATED always  as IDENTITY,
                   grp_name varchar2(20),
                   price number);


declare
 v varchar2(100) :=    DBMS_RANDOM.STRING('A', 100) ;    
 v1 varchar2(50)  :=    DBMS_RANDOM.STRING('A', 50) ;  
begin 

	insert into acs_test (grp_name, price)
    select grp, price from (
    select :g1  grp, dbms_random.value(1,10) as price, floor (DBMS_RANDOM.value( 1, 100) ) n from dual  where :g1 is not null  connect by level <= :g1
    union all
    select :g2 grp , dbms_random.value(1,10) as price,  floor (DBMS_RANDOM.value( 1, 100) ) n from dual where :g2 is not null  connect by level <= :g2
    union all
    select :g3 grp , dbms_random.value(1,10) as price,  floor (DBMS_RANDOM.value( 1, 100) ) n from dual where :g3 is not null  connect by level <= :g3
    union all
    select :g4 grp , dbms_random.value(1,10) as price,  floor (DBMS_RANDOM.value( 1, 100) ) n from dual where :g4 is not null  connect by level <= :g4
) ;

-- insert a few single value records
   insert into acs_test(grp_name, price)
     VALUES ('1','1');
   insert into acs_test(grp_name, price)
     VALUES ('1','1');

    commit;

end;
/

create index IF NOT EXISTS i on acs_test(grp_name);


exec dbms_stats.gather_table_stats(user, 'acs_test', estimate_percent =>100, method_opt=>'for columns grp_name size skewonly');


select grp_name, count(*)
from ACS_TEST
group by grp_name;

set echo off
undefine 1
undefine 2
undefine 3



