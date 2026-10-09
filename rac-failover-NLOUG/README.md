# Does Oracle RAC Failover Really Work?

## Demonstration code

_Note: some of this code was taken from an Oracle Live Lab that is no longer available.  The code was heavily modified for the purpose of the demonstration, but original authors have been credited in the code._

**This is a demonstration of Oracle Transparent Application Continuity (TAC) for Oracle Real Application Cluster (RAC) Databases.  This code is meant for demonstration purposes only and is not production worthy.
**

## Requirements

* Linux system
* JDK 17 or higher (I use OpenJDK)
* Oracle JDBC and UCP drivers (https://www.oracle.com/database/technologies/appdev/jdbc-downloads.html)
* Oracle Notification Services java libarary (From GRID Home ```$GRID_HOME/opmn/lib/ons.jar```)
* Oracle simplefan java library (From GRID Home ```$GRID_HOME/jdbc/lib/simplefan.jar```)

I always recommend using the latest versions of these files. For files from the GRID HOME, I recomend taking them from a software install that has the latest quarterly patch installed.

## Stage the source code

Download the lab scripts and scource code to the Linux system you will run these on.  This should be seperate from the Oracle RAC DB system.

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/main | tar xz --strip=1 --wildcards "ggordham-ora-presentations-???????/rac-failover-NLOUG"
```

## Prepare the database

## Build Programs

# Run Demo

