/* mk_services.sql */
-- Create services for EBR demo
-- Creates two services, BLUE and GREEN

-- grant editions ability ot HR user
ALTER USER hr ENABLE EDITIONS;

BEGIN
 DBMS_SERVICE.CREATE_SERVICE(
     service_name => 'hr_g',
     network_name => 'hr_g',
     edition => 'ora$base');

 DBMS_SERVICE.CREATE_SERVICE(
     service_name => 'hr_b',
     network_name => 'hr_b',
     edition => 'ora$base');
END;
/

COMMIT;

BEGIN
 DBMS_SERVICE.START_SERVICE( service_name => 'hr_g');
 DBMS_SERVICE.START_SERVICE( service_name => 'hr_b');
 END;
 /

 COMMIT;

