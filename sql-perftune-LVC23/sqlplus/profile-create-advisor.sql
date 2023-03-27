/* profile-create-advisor.sql */

/* 
  Run the tuning advisor to create a SQL profile
*/

set echo off

PROMPT ===================== profile-create-advisor.sql ===========================
@@connect.sql

PROMPT
PROMPT Now we will run the tuning advisor which should suggest a
PROMPT  profile to be created to make this SQL run faster.
PROMPT

@@tuning-advisor.sql &prev_sql_id

