/* rm_services.sql */
-- Cleanup services for EBR demo

BEGIN
 DBMS_SERVICE.STOP_SERVICE( service_name => 'hr_g');
 DBMS_SERVICE.STOP_SERVICE( service_name => 'hr_b');
 END;
 /

COMMIT;

BEGIN
 DBMS_SERVICE.DELETE_SERVICE(
     service_name => 'hr_g');

 DBMS_SERVICE.DELETE_SERVICE(
     service_name => 'hr_b');
END;
/

COMMIT;

