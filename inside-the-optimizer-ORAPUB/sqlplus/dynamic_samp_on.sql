/* dynamic_samp_on.sql */

/* 
  setting level 4 enables dynamic sampling for:
    Any table without statistics, 
    OR the SQL has one or more expressions in the WHERE clause predicates 
    OR the SQL has multiple predicates on the same table
  sample size of 64 blocks
*/  

ALTER SESSION SET OPTIMIZER_DYNAMIC_SAMPLING=4;

