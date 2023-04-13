/* profile-show-usage.sql */

/* 
  Show the profile name and usage information
*/

set echo off

PROMPT ===================== profile-Show-usage.sql ===============================
@@connect.sql

PROMPT
PROMPT Lets look at the profile definition and see if any statements
PROMPT   in SQL cache are showing usage (they should not).
PROMPT

@@lsprofile.sal &prev_sql_id

PROMPT
PROMPT Now lets re-run the query and show that the profile is being used 
PROMPT   in the explain plan 
PROMPT

@@profile-q1.sql
@@plans.sql

PROMPT
PROMPT Lets look at the profile definition again 
PROMPT   in SQL cache which should show usage of the profile.
PROMPT
@@list-profile.sql &prev_sql_id

PROMPT
PROMPT This query will show the embeded hints in the profile.
PROMPT
@@profile-viewhint.sql

