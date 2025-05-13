/* drop-patch.sql */

connect / as sysdba

exec DBMS_SQLDIAG.DROP_SQL_PATCH(NAME=>'&1', IGNORE=>TRUE);

