/* v1_dba.sql */
-- used to create v1 edition and grant access to HR user

-- DBA
-- ALTER USER hr ENABLE EDITIONS;
CREATE EDITION v1;
GRANT USE ON EDITION v1 TO hr;

BEGIN
 DBMS_SERVICE.MODIFY_SERVICE(
     service_name => 'hr_g',
     edition => 'v1',
     modify_edition => TRUE);
END;
/

COMMIT;

