
SET pagesize 100
SET linesize 80

SELECT inst_id, sid, serial#, username, service_name, failover_type, failover_method, failed_over
FROM gv$session
WHERE username = 'HR';
