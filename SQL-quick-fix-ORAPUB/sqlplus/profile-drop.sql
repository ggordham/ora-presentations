/* profile-drop.sql */

SET ECHO ON

BEGIN
  FOR REC IN (SELECT name FROM DBA_SQL_PROFILES WHERE sql_text like '%PROFTEST%')
  LOOP
      DBMS_SQLTUNE.DROP_SQL_PROFILE ( name => rec.name);
  END LOOP;
END;
/

COMMIT;

