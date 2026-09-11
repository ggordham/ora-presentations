/* session_edition.sql */

set pagesize 100
set linesize 140

COLUMN username FORMAT A10
COLUMN machine FORMAT A30
COLUMN service_name FORMAT A20
COLUMN program FORMAT A40
COLUMN edition FORMAT A20

SELECT s.sid, s.username, s.machine, s.service_name, s.program,
       o.object_name AS edition
  FROM v$session s, dba_objects o
  WHERE username != 'SYS$BACKGROUND'
    AND s.session_edition_id = o.object_id (+)
    AND o.object_type (+) = 'EDITION';



