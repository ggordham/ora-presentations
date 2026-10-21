# DB Editions

Scripts and steps to setup for the Oracle database edition based redefinition demo.
"Oracle Database Editions Change everything with no downtime"
DOAG -  November, 17th 2026

Some of these scripts are based on examples from Oracle example github repository:
https://github.com/oracle/oracle-db-examples

All code here is use at your own risk, they are intended to be run in a lab system or test system.
These are for training purposes and should not be run in a production or production like environment.

# How to Run

To run this demonstrtion you will need to VM's, PODs, or servers running Linux.

- The first system should be running Oracle database.  Note this demo was tested on Oracle AI Database 26ai free edition but should work on any version from 12.2 and up.
- The second system is a Linux system that has Python 3 and a few additional libraries installed.

The demo will use a schema called HR in the database and run two different Python Flask based applications to demonstrate zero downtime application changes.

## Install DB tier

Download the DB code

```bash
curl -L https://github.com/ggordham/ora-presentations/tarball/master | tar xz --strip=1 --wildcards "ggordham-ora-presentations-???????/db-editions-DOAG/db"

cd db-editions-DOAG/db
```

# Configuration items

In the app folder read the [app README.md](app/README.md) file to understand configuration for the application.

Update the following SQL files based on the passwords, and connection strings needed for your database setup.

- ```db/connect.sql```
- ```db/connect_sys.sql```
- ```db/connect_blue.sql```
- ```db/connect_green.sql```

## Setup database

All DB scripts should be run from the ```db``` directory.

Create HR user
```sql
@connect_sys.sql
setup/cr_user.sql

```
Populate the HR.EMPLOYEES table
```sql
@connect.sql
@setup/employees.sql
```

## Run app v0

Run the first application in your app server:
```bash
./app.py
```
Navigate to the application URL and verify that everything is working:

http://localhost:8000/?wait=0

## Prepare for editions


Shutdown the original application (press CTL+C).

Create services and enable editions
```sql
@connect_sys.sql
SET ECHO ON
@setup/enable_editions.sql
@setup/mk_services.sql
@show_services.sql

```
Move HR objects to edition based view

```sql
@connect_blue.sql
SET ECHO ON
@setup/mv_hr.sql
```

Deploy BLUE application and run v 0.0 on the application server.

```bash
./app-blue.py
```

Navigate to the application URL and verify that everything is working:

http://localhost:8000/?wait=0

You can run the app with a short delay to show the session info

http://localhost:8000/?wait=20

```sql
@session_edition.sql
```

## Deploy v1 edition

_Note we are not shutting down the blue application during this entire process_

Create edition
```sql
@connect_sys.sql
SET ECHO ON
@v1/v1_dba.sql
@show_services.sql

```

Deploy V1 changes

```sql
@connect_green.sql
SET ECHO ON
@show_ed.sql
@v1/cr_departments.sql
@v1/up_employees.sql
@v1/employees_fwdxe_ecode_trg.sql
@v1/employees_v1_transform.sql
@v1/employees_revxe_ecode_trg.sql

```

Deploy v1 GREEN app

Run Green application v1.0

```bash
./app-green.py
```

Navigate to the GREEN app url

http://localhost:9000/?wait=0

You can run the app with a short delay to show the session info

http://localhost:9000/?wait=20

```sql
@session_edition.sql
```

## Deploy v1.1 edition

_Note we do not need to shutdown the blue application while deploying the database changes_

Create edition

```sql
@connect_sys.sql
SET ECHO ON
@v1_1/v1_1_dba.sql
@show_services.sql
```
Deploy v1.1 schema changes

```sql
@connect_blue.sql
SET ECHO ON
@v1_1/up_employees.sql
```

Run blue application v1.1

First we will stop the current blue application (press CTL+C).  Then start the v1.1 version.
```bash
./app-blue_v1.1.py
```

## Optional Move everything to v1.1

When ready we can shutdown the green application and 
Actualize all objects in v1_1

```sql
@connect_blue.sql
SET ECHO ON
@show_ed.sql
@actualize_all.sql
```

Clean up the v1 edition by removing service and grant.
```sql
@connect_sys.sql
SET ECHO ON
@clean_service_v1.sql 
```

## Remove demo

You can remove the demo by stopping the applications.  Then drop the HR user, remove the services and remove the created editions.

```sql
@connect_sys.sql
SET ECHO ON
drop user hr cascade;
@sertup/rm_services.sql
drop edition v1_1;
drop edition v1;
@all_editions.sql
@show_services.sql
```