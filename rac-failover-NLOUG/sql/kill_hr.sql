/* kill_hr.sql */

-- simple script to kill one HR user session
-- must be run on DB server with active sessions

set heading off
set termout off

column s_pid new_value spid
col s_pid noprint

set feedback on

SELECT
    -- s.inst_id, s.sid, s.serial#, s.status,
    -- s.process AS f_pid, s.program AS f_program, s.terminal AS f_terminal,
    -- p.terminal AS s_terminal, 
       p.spid AS s_pid 
    -- , p.program AS s_program, 
    -- s.osuser, s.machine, s.username,
    -- s.logon_time
  FROM gv$session s, gv$process p
  WHERE s.paddr = p.addr
    -- AND s.status = 'ACTIVE'
    AND s.username = 'HR'
    AND rownum = 1;

HOST pkill &spid

set termout on
set heading on

