/* show_spd_detail.sql */

set echo off
set long 9999
column directive_id format 999999999999999999999
column spd_text format a50
column internal_state format a15

set echo on
SELECT directive_id,
            state,
            TO_CHAR(last_used,'YYYYMMDD') last_used,
            auto_drop,
            enabled,
            Extract( notes, '/spd_note/spd_text/text()' )       spd_text,
            Extract( notes, '/spd_note/internal_state/text()' ) internal_state
     FROM   DBA_SQL_PLAN_DIRECTIVES
     WHERE  directive_id IN
            ( SELECT directive_id
              FROM   DBA_SQL_PLAN_DIR_OBJECTS
              WHERE owner = '&1'
                AND object_name = '&2');


set echo off
