
set echo on

BEGIN DBMS_AUTO_TASK_ADMIN.ENABLE (
client_name => 'auto optimizer stats collection' , operation => NULL
, window_name => NULL
);
END;
/

@@auto_stat
