set verify off
SET SERVEROUTPUT ON

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
   v_batch NUMBER := 200000;
   v_return NUMBER;
   v_loop NUMBER;
   v_left NUMBER;
   v_total NUMBER;

FUNCTION mk_row (p_qty NUMBER) RETURN NUMBER IS
BEGIN 

    v_total := 0;

    IF p_qty < v_batch THEN
        insert into acs_test (grp_name, price)
            select grp, price from (
               select p_qty  grp, dbms_random.value(1,10) as price, floor (DBMS_RANDOM.value( 1, 100) ) n from dual  where :g1 is not null  connect by level <= p_qty);
        v_total := v_total + SQL%ROWCOUNT;
        COMMIT;
    ELSE
        v_loop := p_qty / v_batch;
        v_left := MOD(p_qty, v_batch);
        DBMS_OUTPUT.PUT_LINE( 'Loop count ' || v_loop);
        DBMS_OUTPUT.PUT_LINE( 'Remainder  ' || v_left);
        FOR i in 1..v_loop LOOP
             insert /*+ APPEND */ into acs_test (grp_name, price)
                   select grp, price from (
                        select p_qty  grp, dbms_random.value(1,10) as price, floor (DBMS_RANDOM.value( 1, 100) ) n from dual  where :g1 is not null  connect by level <= v_batch);
             v_total := v_total + SQL%ROWCOUNT;
             DBMS_OUTPUT.PUT_LINE( SQL%ROWCOUNT || ' Rows inserted');
             COMMIT;
        END LOOP; 

        IF v_left > 0 THEN
            insert into acs_test (grp_name, price)
                select grp, price from (
                   select p_qty  grp, dbms_random.value(1,10) as price, floor (DBMS_RANDOM.value( 1, 100) ) n from dual  where :g1 is not null  connect by level <= v_left );
            v_total := v_total + SQL%ROWCOUNT;
            COMMIT;
        END IF;

    END IF;

    RETURN v_total;

END mk_row;

BEGIN

    v_return := mk_row(:g1); 
    DBMS_OUTPUT.PUT_LINE( v_return || ' Rows inserted total');
    v_return := mk_row(:g2); 
    DBMS_OUTPUT.PUT_LINE( v_return || ' Rows inserted total');
    v_return := mk_row(:g3); 
    DBMS_OUTPUT.PUT_LINE( v_return || ' Rows inserted total');

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



