/* employees_revxe_ecode_trg.sql */

-- Alway set the expected edtion just in case
ALTER SESSION SET EDITION=v1;

-- Create reverse eidtion trigger to push data to old version
CREATE OR REPLACE TRIGGER employees_revxe_ecode_trg
  BEFORE INSERT OR UPDATE OF department_id, manager_id ON hr.employees$0
  FOR EACH ROW
  REVERSE CROSSEDITION
  DISABLE
DECLARE
    v_department_name VARCHAR2(30);
BEGIN

    SELECT d.department_name INTO v_department_name
      FROM departments$0 d 
      WHERE d.department_id = :new.department_id;

  :new.employee_code := UPPER(REPLACE(SUBSTR(v_department_name,1,5),' ','_'))
        || '-'||TO_CHAR(:new.manager_id,'FM000')||'-'||TO_CHAR(:new.employee_id,'FM0000');
END;
/

ALTER TRIGGER employees_revxe_ecode_trg ENABLE;


