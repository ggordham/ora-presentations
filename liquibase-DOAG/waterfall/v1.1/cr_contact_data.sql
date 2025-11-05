--liquibase formatted sql
--changeset ggordham:migrate-emp-contact-data-to-emp_contact-table runWithSpoolFile:cr_contact_data_spool.log
insert into emp_contact (contact_id, employee_id, contact_type, contact)
   select contact_id_seq.nextval, employee_id, 'PHONE', phone_number 
     from employees;

