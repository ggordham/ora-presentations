
COLUMN reop FORMAT A4
COLUMN adap FORMAT A4
COLUMN bina FORMAT A4
COLUMN bins FORMAT A4

select sql_id, child_number, plan_hash_value, 
       is_reoptimizable AS reop, 
       is_resolved_adaptive_plan AS adap, 
       is_bind_aware AS bina, 
       is_bind_sensitive AS bins
  from v$sql where sql_id = '&1';


