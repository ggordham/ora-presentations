/* add_social.sql */

SET ECHO ON

ALTER TABLE sh.customers ADD (social_id VARCHAR2(10));

UPDATE sh.customers SET social_id = DECODE(SUBSTR(cust_state_province,1,2),'CA','XXXXXX',TO_CHAR(cust_id));
COMMIT;

SET ECHO OFF

