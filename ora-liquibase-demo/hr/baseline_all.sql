/* baseline_all.sql */

/* quick script to apply the baseline to all schemas. */

cd base

connect hr_prd/hr_prd_pa55wd@//srvr08/pdb1

lb changelog-sync -changelog-file controller.xml
lb tag -tag v1.0

connect hr_tst/hr_tst_pa55wd@//srvr08/pdb1

lb changelog-sync -changelog-file controller.xml
lb tag -tag v1.0

connect hr_dev/hr_dev_pa55wd@//srvr08/pdb1

lb changelog-sync -changelog-file controller.xml
lb tag -tag v1.0

cd ..

