/* kill_hr.sql */

-- simple script to kill one HR user session
-- must be run on DB server with active sessions

column s_pid new_value spid
set heading off
set termout off
col s_pid noprint

SELECT
    -- s.inst_id, s.sid, s.serial#, 
    -- s.process AS f_pid, s.program AS f_program, s.terminal AS f_terminal,
    -- p.terminal AS s_terminal, 
       p.spid AS s_pid 
    -- , p.program AS s_program, 
    -- s.osuser, s.machine, s.username,
    -- s.logon_time
  FROM gv$session s, gv$process p
  WHERE s.paddr = p.addr
    AND s.username = 'HR'
    AND rownum = 1;

HOST pkill &spid

