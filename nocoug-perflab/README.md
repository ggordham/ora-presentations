# nocoug-perflab
Scripts from the NOCOUG performance lab presentation Nov 19, 2020

These scripts are mostly based on examples from the Oracle example github repository:
https://github.com/oracle/oracle-db-examples

All code here is use at your own risk, they are intended to be run in a lab system or test system.
These are for training purposes and should not be run in a production or production like environment.

The scripts have been modified for the purpose of the lab and to make them easy to step through for instructional purposes.

## Download the Scripts
You can run the following command from Linux or MAC OSX or Cygwin to download all the items in the repository.

`curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1`

## Basic Setup Steps
Run script lab-setup.sql as a user in the database with DBA rights (E.G. SYS or SYSTEM)

`cd nocoug-perflab`  
`sqlplus /nolog`  
`SQL> connect / as sysdba`  
`SQL> @lab-setup`  
`exit`  

Under each directory are examples for each topic area

## Plans
Walks through examples of generating explain plans.  Note the outline information and the different formatting options for example explain plans.
Change into the plans directory.  Connect to the database using the perflab user.
The example scripts will step through, Press ENTER when prompted at each step

`cd plans`  
`sqlplus /nolog`  
`SQL> connect perflab/perf$lab`  
`SQL> @ctables.sql `  

1. Explain with all sections:

   `SQL> @eg1.sql`

   Look at eg1.sql file to review SQL query
   Look at plan.sql file to review explain plan syntax

2. Explain with detailed statistics:

   `SQL> @eg2.sql`

   Look at eg2.sql file to review SQL query with additional hint
   Look at stats.sql file to review explain plan syntax

3. Monitor SQL:

  `SQL> @eg3.sql`

  Look at eg3.sql to review syntax for monitor SQL

4. Tag / find SQL in v$sql table:

   `SQL> @eg4.sql`

  Look at eg4.sql to review hint for tagging, and syntax to find

5. Combines examples 3 and 4

  `SQL> @eg5.sql`

   (mark SQL for easy identification in v$sql then run SQL monitor report on it)

6. Look at the explain plan for a parallel query

   `SQL> @eg6.sql`

7. Example of finding the SQL ID of the last statement from your session

   `SQL> @last.sql`

Exit SQLPlus

## Stats
Example looking at object and system stats
Change into the plans directory.  Connect to the database using a user with DBA privileges (E.G. SYS or SYSTEM)

`cd stats`  
`sqlplus /nolog`  
`SQL> connect / as sysdba`  
`exit`  

1. Show table and column statistics for the objects used in the plans lab.

   `SQL> @eg1.sql`

   Also shows the status of automated statistics collection job

2. Enable or Disable the automated statistics job based on current status

   `SQL> @dis_auto_stats.sql`  
    `SQL> @en_auto_stats.sql`  

   Be sure you leave the job in the state you want (enabled or disabled)

3. Change the automatic statistics job to run on Mondays, modify the percent stale rows used to decide when to run stats for the PERFLAB.EMPLOYEE table, and show the tables in the database with stale statistics.

   `SQL> @eg2.sql`

**This next example will play with system statistics.  Be sure to put things back the way you want when done.**

4. This first script will load a example set of system stats that have been gathered.

  `SQL> @perf-lab-sys-stats-stg.sql`

5. Show current system statistics, load statistics from no-workload gathering, and load statistics from a workload gathering.  

  `SQL> @eg3.sql`

**post this example you should set your system statistics back to the default**
The first script will set your system back to no workload system stats based on your hardware.
The second script will show the values of your system stats.

`SQL> @sysstat_del.sql`  
`SQL> @sysstat_val.sql`  

Exit SQLPlus

## SQL Plan Management
Examples using SQL Plan Management
Change into the patch directory.  Create the needed tables, and step through the examples.  Note user connections are hard coded into these scripts.
The example scripts will step through, Press ENTER when prompted at each step

`cd spm`  
`sqlplus /nolog`  
`SQL> @ctables`  

1. testsRun through first test – two plans for the same SQL

`SQL> @test1`

2.	Run through second test – remove the extended stats

`SQL> @test2`

3.	Run through third test – create a baseline

`SQL> @test3`

**Be sure to copy the plan hash value from the query to the SPM create baseline!**

Exit SQLPlus

## SQL patch
Change into the patch directory.  Create the needed tables, and step through the examples.  Note user connections are hard coded into these scripts.
The example scripts will step through, Press ENTER when prompted at each step

`cd patch`  
`sqlplus /nolog`  
`SQL> @ctables`  

1. Run through first test – simple patch using outline hint

`SQL> @test1`

2.	Run through second test – remove usage of hint embedded

`SQL> @test2`

3.	Run through third test – copy plan from one SQL to another

`SQL> @test3`

Exit SQLPlus

## Further information
Hopefully these scripts / labs will help increase the number of tools you can use for performance issues on Oracle database.

See more at my blog http://oraontap.com
Or reach out to me on Twitter: https://twitter.com/ggordham
