# Example of how to create a SQL profile

See example.lst for a full listing of the scenario.

### DISCLAIMER

*  These scripts are provided for educational purposes only.
*  They are NOT supported by Oracle World Wide Technical Support.
*  The scripts have been tested and they appear to work as intended.
*  You should always run scripts on a test instance.

### WARNING

*  These scripts drop and create tables. For use on test databases.

Setup the lab
@lab-setup

connect perflab/perf$lab

create tables
@tab

Run the query and View the execution plan
@q1
@plan

Trace the query
@purge 70nv63r37j039
@trace no_profile

Run the SQL tuning advisor
@tune
@report
@accept

Show that we have a profile now
@lsprofile

Re-run the query to show the profile is in use
@q1
@plan

Show that the profile usage is in cursor cache
@lsprofile

See the hints in the profile
@viewhint

Trace the profile
@purge 70nv63r37j039
@trace profile


