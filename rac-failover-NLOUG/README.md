# Does Oracle RAC Fail over Really Work?

## Demonstration code

_Note: some of this code was taken from an Oracle Live Lab that is no longer available.  The code was heavily modified for the purpose of the demonstration, but original authors have been credited in the code._

**This is a demonstration of Oracle Transparent Application Continuity (TAC) for Oracle Real Application Cluster (RAC) Databases.  This code is meant for demonstration purposes only and is not production worthy.**

## Requirements

* Linux system
* JDK 17 or higher (I use OpenJDK)
* ant package installed
* Oracle JDBC and UCP drivers (https://www.oracle.com/database/technologies/appdev/jdbc-downloads.html)
* Oracle Notification Services java libarary (From GRID Home ```$GRID_HOME/opmn/lib/ons.jar```)
* Oracle simplefan java library (From GRID Home ```$GRID_HOME/jdbc/lib/simplefan.jar```)

I always recommend using the latest versions of these files. For files from the GRID HOME, I recommend taking them from a software install that has the latest quarterly patch installed.

## Stage the source code

Download the lab scripts and scource code to the Linux system you will run these on.  This should be seperate from the Oracle RAC DB system.

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 --wildcards "ggordham-ora-presentations-???????/rac-failover-NLOUG"
```

Run the init to build all the required directories:

```bash 
ant init
```

Place the required Java libraries in the lib directory.  Note, compiling and running the demo will fail if any of these are missing.

```
./lib/ojdbc17.jar
./lib/ons.jar
./lib/simplefan.jar
./lib/ucp17.jar
```

_Note: you can update the versions based on your Java version, but be sure to update the file names in the MANIFEST and build.xml files._

## Prepare the database

As the oracle OS user on the RAC cluster, create the required services for both TAC and non-TAC connections.  Update the script prior to running with any changes in instance or database names.

```bash
db/mk_rac_services.sh
```

After running, verify that the services are present and running using the following SQL query as a DBA level user on the RAC database.

```sql
select a.inst_id, a.name, a.network_name,  a.blocked, a.goal,
       a.clb_goal, a.aq_ha_notification as fan_enabled, a.commit_outcome,
       a.retention_time, a.replay_initiation_timeout, a.session_state_consistency,
       a.stop_option, a.failover_restore, a.drain_timeout
  from gv$active_services a
  where name NOT LIKE 'SYS$%'
```

Create the HR schema for the demonstartion.  Run the following script from sqlplus.  Be sure to update the connection string or password to match your system. 

```sql
@db/cr_hr.sql
```

_Note: this is a temporary HR schema with only one table and does not use the standard HR demo schema from Oracle._

## Build Programs

Run the ant build on the "app" tier Linux server.

```bash
cd rac-failover-NLOUG
ant all
```

# Run Demo

The following commands are used throughout the demo.  They are in no specific order.  

### Database commands

Note all database commands are run from a local session running on node one of the database server.  When we kill nodes, we kill node 2 as to not interfere with the commands.
```bash
# start SQLcl
$ORACLE_HOME/sqlcl/bin/sql /nolog
```
```sql
-- Connect to database
connect / as sysdba

-- show service status
-- NO TAC
host srvctl status service -d orcl -s hr_notac

-- TAC
host srvctl status service -d orcl -s hr_tac

-- relocate service from one node to another
-- NO TAC
host srvctl relocate service -d orcl -s hr_notac -oldinst orcl2 -newinst orcl1  -drain_timeout 0

host srvctl relocate service -d orcl -s hr_notac -oldinst orcl1 -newinst orcl2  -drain_timeout 30

-- TAC
host srvctl relocate service -d orcl -s hr_tac -oldinst orcl1 -newinst orcl2  -drain_timeout 0

host srvctl relocate service -d orcl -s hr_tac -oldinst orcl2 -newinst orcl1  -drain_timeout 30

-- show service status
@sql/service_status.sql

-- Show application sessions
@sql/session_tac.sql

-- Kill a "random" HR user session
@sql/kill_hr.sql
```

### Replay commands

```bash
# run replay with NO TAC
./runnoreplay

# run replay with TAC
./runreplay

# start watchfan
./runwatchfan
```

_Note: each demo should be run for TAC and NO TAC configuration.  You will need to update the ```fanwatcher.properties``` manually between runs to change the service name you are watching._

## Demo 1 - kill session

We kill the dedicated session process on the database server from the OS side. This would be similar to a network issue that only affects a few sessions such as a flapping port.  The demo is repeated twice, once for application without TAC, and one with TAC enabled. 

Steps:
1. show service location
2. start load
3. view session info
4. kill session
5. show metrics

## Demo 2 - relocate service 

In this demo we will move the service from one node to the other.  This demonstrates standard planned maintenance where you would take down the system one node at a time.  We will do a relocation with zero drain time (default) and then with 30 seconds.

Steps:
1. Start watchfan
2. show service location
3. start load
4. view session info
5. relocate with zero drain time
6. show metrics
7. relocate with 30 second drain time
8. show metrics

## Demo 3 - Node down

This demo is an example of a node outage.  Please note that the speed at which the node outage is detected is based on the RAC configuration and timeouts for how quick the node discoveres there is an issue.

Steps:
1. Start watchfan
2. show service location
3. start load
4. kill node
5. Show outcome
