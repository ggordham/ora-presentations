--liquibase formatted sql
--changeset (HR_DEV)-Generated:upd_emp_contact_proc_v1.0 endDelimiter:/
--comment v1.0 of procedure
CREATE OR REPLACE PROCEDURE upd_emp_contact_proc
  (p_emp_id IN NUMBER, 
   p_contact_code IN CHAR,
   p_contact IN VARCHAR2) 
AS
    v_contact_type emp_contact.contact_type%TYPE;
BEGIN
  CASE p_contact_code
    WHEN 'P' THEN v_contact_type := 'PHONE';
    WHEN 'E' THEN v_contact_type := 'EMAIL';
    ELSE raise_application_error( -20000, 'Invalid contact code provided!');
  END CASE;

  MERGE INTO emp_contact  
      USING dual ON (p_emp_id = employee_id AND v_contact_type = contact_type)
      WHEN NOT MATCHED THEN INSERT (contact_id, employee_id, contact_type, contact)
        VALUES (contact_id_seq.nextval, p_emp_id, v_contact_type, p_contact)
      WHEN MATCHED THEN UPDATE 
        SET contact = p_contact;
        
END;
/
--rollback DROP PROCEDURE upd_emp_contact_proc

