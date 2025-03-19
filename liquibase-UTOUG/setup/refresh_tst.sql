/* refresh_tst.sql */

whenever sqlerror exit

PROMPT Refresh TEST HR system, schema will be dropped.
PROMPT   Press CTL+C to exit, or enter to continue
DEFINE v_ask = '&are_you_sure';

PROMPT Enter system password (required)
DEFINE v_system_pass = '&1';

connect system/&&v_system_pass

alter session set container=hrtst;

drop user hr cascade;

create database link hrprd connect to system identified by &&v_system_pass using '//localhost/hrprd';

declare
  v_dp_handle       number;
  v_job_state       user_datapump_jobs.state%TYPE; 

begin
  -- Open a schema import job.
  v_dp_handle := dbms_datapump.open(
    operation   => 'IMPORT',
    job_mode    => 'SCHEMA',
    remote_link => 'HRPRD',
    job_name    => 'HRTST_REFRESH',
    version     => 'LATEST');

  -- Specify the schema to be imported.
  dbms_datapump.metadata_filter(
    handle => v_dp_handle,
    name   => 'SCHEMA_EXPR',
    value  => '= ''HR''');

  -- Specify the log file name and directory object name.
  dbms_datapump.add_file(
    handle    => v_dp_handle,
    filename  => 'hrtst-refresh.log',
    directory => 'DATA_PUMP_DIR',
    filetype  => DBMS_DATAPUMP.KU$_FILE_TYPE_LOG_FILE);

  dbms_datapump.start_job(v_dp_handle);

  dbms_datapump.wait_for_job(v_dp_handle,v_job_state);

end;
/

drop database link hrprd;

--  "${ORACLE_HOME}"/bin/impdp "system/@hrtst" directory="DATA_PUMP_DIR" network_link=hrprd logfile=hrtst-refersh.log TRANSFORM=OID:N schemas=hr



