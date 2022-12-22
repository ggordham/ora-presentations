connect perflab/perf$lab&con_pdb

set echo on
spool ctables.log
--
-- Enable ORDS in the perflab schema
BEGIN
  ORDS.enable_schema(
    p_enabled             => TRUE,
    p_schema              => 'PERFLAB',
    p_url_mapping_type    => 'BASE_PATH',
    p_url_mapping_pattern => 'perflab',
    p_auto_rest_auth      => FALSE
  );
    
  COMMIT;
END;
/

