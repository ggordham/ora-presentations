/* clean_service_v1.sql */

BEGIN
 DBMS_SERVICE.MODIFY_SERVICE(
     service_name => 'hr_g',
     edition => 'v1_1',
     modify_edition => TRUE);
END;
/

COMMIT;

REVOKE USE ON EDITION v1 FROM hr;


