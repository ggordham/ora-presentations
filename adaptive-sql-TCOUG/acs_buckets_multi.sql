/* acs_bucket_multi.sql */


set verify off
set define on
set pagesize 2000
set linesize window
set echo on
set serveroutput on


-- you can comment is and flush shared_pool manually
-- alter session set statistics_level  = &3;

var grp varchar2(100)
var b1 varchar2(100)
var b2 varchar2(100)
var b3 varchar2(100)
var b4 varchar2(100)
begin
    :grp := '&1';
    :b1 := '&1';
    :b2 := '&2';
    :b3 := '&3';
    :b4 := '&4';
end;
/

@@connect_sys.sql
@@purge-cursor.sql g89xvwavgqpha

@@connect.sql

select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;

@@plans.sql
@@cursors.sql g89xvwavgqpha

begin
    :grp := :b2;
end;
/
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;

@@plans.sql
@@cursors.sql g89xvwavgqpha


begin
    :grp := :b3;
end;
/

select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;

@@plans.sql
@@cursors.sql g89xvwavgqpha

begin
    :grp := :b4;
end;
/

select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;
select /*+ gather_plan_statistics */ grp_name, max(id), sum(price) from acs_test a where grp_name = :grp GROUP BY grp_name;

@@plans.sql
@@cursors.sql g89xvwavgqpha
@@cursor_share.sql g89xvwavgqpha
@@shared_cursor_reason.sql g89xvwavgqpha

select child_number, bucket_id, count
From v$sql_cs_histogram
where sql_id = 'g89xvwavgqpha';

