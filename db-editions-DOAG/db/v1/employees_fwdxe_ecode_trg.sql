/* employees_fwdxe_ecode_trg.sql */

-- Alway set the expected edtion just in case
ALTER SESSION SET EDITION=v1;

-- Create forward edition trigger in previous edition
CREATE OR REPLACE TRIGGER hr.employees_fwdxe_ecode_trg
  BEFORE INSERT OR UPDATE OF employee_code ON hr.employees$0
  FOR EACH ROW
  FORWARD CROSSEDITION
  DISABLE
DECLARE
    v_dept_id    NUMBER;
    v_manager_id NUMBER;

BEGIN 
      SELECT d.department_id INTO v_dept_id FROM hr.departments$0 d 
          WHERE SUBSTR(:new.employee_code,1,INSTR(:new.employee_code,'-')-1) = 
                SUBSTR(UPPER(d.department_name),1,LENGTH(SUBSTR(:new.employee_code,1,INSTR(:new.employee_code,'-')-1)));
      :new.department_id := v_dept_id;

      :new.manager_id := TO_NUMBER(SUBSTR(:new.employee_code,INSTR(:new.employee_code,'-')+1,3));
      -- if the employee has no manger, then set the manager_id to null
      --  the number will be negative if the second dash is the first character of the employee-code
      IF :new.manager_id < 0 THEN
          :new.manager_id := NULL;
      END IF;

end;
/

ALTER TRIGGER employees_fwdxe_ecode_trg ENABLE;


-- Check that the trigger enabled ok and did not get stuck on DDL locks
DECLARE
  scn number := null;
  -- A null or negative value for Timeout will cause a very long wait.
  timeout constant integer := null;

BEGIN
  if not sys.dbms_utility.wait_on_pending_dml(
    tables => 'EMPLOYEES$0',
    timeout => timeout,
    scn => scn)
  then
    raise_application_error(-20000,
      'wait_on_pending_dml() timed out. '||
      'CET was enabled before SCN: '||SCN
    );
  end if;
end;
/


