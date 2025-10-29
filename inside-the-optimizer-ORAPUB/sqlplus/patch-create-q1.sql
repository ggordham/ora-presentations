/* patch-create-q1.sql */

SET ECHO OFF

PROMPT
PROMPT connect as the SYS user to create the patch
PROMPT

CONNECT / AS SYSDBA


SET ECHO ON

DECLARE
  l_patch_name VARCHAR2(4000);
BEGIN
  l_patch_name := sys.dbms_sqldiag.create_sql_patch(
                                sql_id => '&1',
                                hint_text =>'IGNORE_OPTIM_EMBEDDED_HINTS', 
                                name      =>'sql_&1._patch');
END;
/

SET ECHO OFF

