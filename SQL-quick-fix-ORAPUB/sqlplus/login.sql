/* login.sql */

-- Simple login script for lab to set prompt

set pagesize 999
set linesize 200
ALTER SESSION SET nls_date_format = 'HH:MI:SS';
SET SQLPROMPT "_USER'@'_CONNECT_IDENTIFIER _DATE> "
ALTER SESSION SET nls_date_format = 'YYYY-MM-DD HH24:MI:SS';

