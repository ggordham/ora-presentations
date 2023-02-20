set linesize 1000
set pagesize 100
set trims on
set tab off
set echo on
--
-- Create the test table and fill it
-- with data that has a large range skew
-- so that cardinality estimate is wrong.
--
@tab
--
-- Drop any SQL profiles from a previous run
--
@drop
--
-- Run our test query
--
@purge g6y6gpnzww95b

-- enable query level statistics to be gathered
ALTER SESSION SET statistics_level=ALL;

@trace no_profile
-- @q1
--
-- Get the SQL execution plan
--
@plan

--
-- See plan above - We get a FULL scan: the cardinality estimate is wrong
--
pause Press <CR> to continue...

--
-- Run the SQL tuning advisor
--
@tune

--
-- run the SQL tuning advisor report
--
@report

--
-- See above: a SQL profile is recommended
--
pause Press <CR> to continue...

--
-- Accept the profile
--
@accept

--
-- Run the query again
--
@purge g6y6gpnzww95b
@trace profile
-- @q1

@plan
--
-- See plan above - we now get index access and the SQL profile is being used
--

--
-- Notice how SQL_PROFILE is filled in for Q1
--
@sql

--
-- Look at the SQL Profile
--
@look

@view

