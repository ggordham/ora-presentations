/* v1_1_dba.sql */
-- used to create v1_1 edition and grant access to HR user

-- DBA
-- ALTER USER hr ENABLE EDITIONS;
CREATE EDITION v1_1 AS CHILD OF v1;
GRANT USE ON EDITION v1_1 TO hr;

BEGIN
 DBMS_SERVICE.MODIFY_SERVICE(
     service_name => 'hr_b',
     edition => 'v1_1',
     modify_edition => TRUE);
END;
/

COMMIT;

