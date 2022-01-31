set echo on

BEGIN DBMS_SCHEDULER.SET_ATTRIBUTE (
               'MONDAY_WINDOW',
               'repeat_interval',
              'freq=daily;byday=MON;byhour=05;byminute=0;bysecond=0' );
END; 
/

