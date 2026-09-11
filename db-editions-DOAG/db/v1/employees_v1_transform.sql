/* employees_v1_transform.sql */

-- Alway set the expected edtion just in case
ALTER SESSION SET EDITION=v1;

declare
  cur integer := sys.dbms_sql.open_cursor(security_level => 2);
  no_of_updated_rows integer not null := -1;
begin
  sys.dbms_sql.parse(
    c => cur,
    language_flag => sys.dbms_sql.native,
    statement => 'update employees$0 set employee_code = employee_code',
    apply_crossedition_trigger => 'employees_fwdxe_ecode_trg',
    fire_apply_trigger => true
  );
  no_of_updated_rows := sys.dbms_sql.execute(cur);
  sys.dbms_sql.close_cursor(cur);
end;
/

-- COMMIT the record updates
COMMIT;


