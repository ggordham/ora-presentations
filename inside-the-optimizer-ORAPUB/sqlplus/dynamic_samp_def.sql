/* dynamic_samp_def.sql */

/* 
  setting level 2 (default) enables dynamic sampling for:
    Any table without statistics, 
  sample size of 64 blocks
*/  

ALTER SESSION SET OPTIMIZER_DYNAMIC_SAMPLING=2;

