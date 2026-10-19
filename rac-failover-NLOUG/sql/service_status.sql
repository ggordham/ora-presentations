SELECT name, 
       failover_type, 
       failover_method, 
       commit_outcome, 
       failover_restore
FROM dba_services
WHERE name like 'hr%';
