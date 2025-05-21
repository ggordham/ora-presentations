
/* customers_bind_aware.sql */

/*
-- first run small number of rows (16), index range scan

   CHILD_NUMBER    EXECUTIONS    BUFFER_GETS IS_BIND_SENSITIVE    IS_BIND_AWARE    
_______________ _____________ ______________ ____________________ ________________ 
              0             1             19 Y                    N                

-- second run large number of rows (3341), index range scan used

   CHILD_NUMBER    EXECUTIONS    BUFFER_GETS IS_BIND_SENSITIVE    IS_BIND_AWARE    
_______________ _____________ ______________ ____________________ ________________ 
              0             2           1083 Y                    N                

-- thrid run large number of rows (3341), index fast full scan used

   CHILD_NUMBER    EXECUTIONS    BUFFER_GETS IS_BIND_SENSITIVE    IS_BIND_AWARE    
_______________ _____________ ______________ ____________________ ________________ 
              0             2           1083 Y                    N                
              1             1            132 Y                    Y                

-- forth run small number of rows (16), index range scan 

CHILD_NUMBER PLAN_HASH_VALUE EXECUTIONS BUFFER_GETS IS_BIND_SENSITIVE IS_BIND_AWARE 
____________ _______________ __________ ___________ _________________ _____________ 
           0       558307901          2        1486 Y                 N             
           1       270892308          1         156 Y                 Y             
           2       558307901          1          18 Y                 Y  
*/

prompt ========================== bind peeking / aware SQL ==========================================
PROMPT
PROMPT "First we make sure there is an index on the column we are using for the predicate."
PROMPT

-- create index sh.customers_prov on sh.customers(cust_state_province);
-- exec dbms_stats.gather_schema_stats('SH');

var cust_prov varchar2(256)

PROMPT "For each query run look at the count of rows processed, the execution plan"
PROMPT "  and the status in v$sql for bind_aware, bind_sensitive, and buffer_gets"
PROMPT
PROMPT "=== The first time this query runs it will look at a small number of rows."

exec :cust_prov := 'Tokyo'

select /*+ gather_plan_statistics */ /*ACS_1*/ count(1), max(cust_id)
     from sh.customers
     where cust_state_province = :cust_prov;

@@plans.sql
@@cursors.sql 6tdjh6rt27mt2

PROMPT
PROMPT "=== The second time this query runs it will look at a large number of rows."
PROMPT "=== no plan change."

exec :cust_prov := 'CA'

select /*+ gather_plan_statistics */ /*ACS_1*/ count(1), max(cust_id)
     from sh.customers
     where cust_state_province = :cust_prov;

@@plans.sql
@@cursors.sql 6tdjh6rt27mt2

PROMPT
PROMPT "=== The third time this query runs it will look at a large number of rows."
PROMPT "=== now there will be a plan change."

exec :cust_prov := 'CA'

select /*+ gather_plan_statistics */ /*ACS_1*/ count(1), max(cust_id)
     from sh.customers
     where cust_state_province = :cust_prov;

@@plans.sql
@@cursors.sql 6tdjh6rt27mt2

PROMPT
PROMPT "=== The fourth time this query runs it will look at a small number of rows."
PROMPT "=== A new cursor will be created matching the first plan, but bind aware."

exec :cust_prov := 'Tokyo'

select /*+ gather_plan_statistics */ /*ACS_1*/ count(1), max(cust_id)
     from sh.customers
     where cust_state_province = :cust_prov;

@@plans.sql
@@cursors.sql 6tdjh6rt27mt2

prompt ========================== end bind peeking / aware SQL ======================================
