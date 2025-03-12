# UTOUG SQL Hint quick tip

Quick tip on how to use SQL Patch to embed a SQL hint into a SQL statement without changing the original SQL code.

### DISCLAIMER

*  These scripts are provided for educational purposes only.
*  They are NOT supported by Oracle World Wide Technical Support.
*  The scripts have been tested and they appear to work as intended.
*  You should always run scripts on a test instance.

### WARNING

*  These scripts drop and create tables. For use on test databases.

All code here is use at your own risk, they are intended to be run in a lab system or test system.
These are for training purposes and should not be run in a production or production like environment.

The scripts have been modified for the purpose of the lab and to make them easy to step through for instructional purposes.

## Requirements

This demonstartion requires:

 - Oracle database version 19c or above. 
 - Oracle SAMPLE schemas for HR https://github.com/oracle-samples/db-sample-schemas

## Running through the demonstration

Connect to your database, if you are using a PDB be sure to adjust any connect strings and the connect.sql based on your system.

```bash
sqlplus /nolog

```

Create the required user to run queries.

```sql
connect / as sysdba
@@user_setup.sql

```

Run the test query to get it into cursor cache and see the execution plan

```sql
@@connect.sql
@@q1.sql
@@plans.sql

```
 
 Now lets hint the SQL and look at the hint report to identify where the issues are.
 
 ```sql
 @@q1-hint-bad.sql
 @@plans.sql
 
 ```
 
 Ok so once we know what the issues are, lets fix the hints and get the statement to use indexes.
 
 ```sql
 @@q1-hint-good.sql
 @@plans.sql
 
 ```
 
 Now we can create a patch by bringing the specific outline hints into the new statement.  Note we have updated the view names to match the original statement even though we took the outline code from the updated statement.

```sql
connect / as sysdba

set echo on
DECLARE
  pname VARCHAR2(4000);
BEGIN
  pname := sys.dbms_sqldiag.create_sql_patch(
                sql_id    => 'fc25kvvvb1aar',
                hint_text => 'INDEX(@"SEL$F5BB74E1" "C"@"SEL$1" ("CUSTOMERS"."CUST_ID")) '||   
                             'BITMAP_TREE(@"SEL$F5BB74E1" "S"@"SEL$1" AND(("SALES"."CHANNEL_ID")))',
name     => 'sql_fc25kvvvb1aar_index');
END;
/

```

Now lets verify the patch works, we should also verify the patch is in place and can view the stored hints.

```sql
@@q1.sql
@@plans.sql

```

View the patch and the embeded hints

```sql
@@list-patch.sql
@@patch-see-hint fc25kvvvb1aar

```

To clean up and drop the patch run:

```sql
@@drop-patch.sql sql_fc25kvvvb1aar_patch

```

Also note that you could copy the entire execution plan from the hinted SQL to the orgianl SQL using a script like this:

```sql
@cp-plan-patch.sql fc25kvvvb1aar fg3r46v0twq4h

```

This should give you output like this to run to crete the patch:

```sql
-- run the following block to create the patch
DECLARE
  pname VARCHAR2(4000);
BEGIN

  pname := sys.dbms_sqldiag.create_sql_patch(
                   sql_id    => 'fc25kvvvb1aar',
                   hint_text =>'IGNORE_OPTIM_EMBEDDED_HINTS '||
                               'OPTIMIZER_FEATURES_ENABLE(''19.1.0'') '||
                               'DB_VERSION(''19.1.0'') '||
                               'ALL_ROWS '||
                               'OUTLINE_LEAF(@"SEL$C1C92257") '||
                               'OUTLINE_LEAF(@"SEL$09FF82E3") '||
                               'PLACE_GROUP_BY(@"SEL$F5BB74E1" ( "S"@"SEL$1"   "CH"@"SEL$2" ) 10) '||
                               'OUTLINE(@"SEL$67910E1A") '||
                               'OUTLINE(@"SEL$F5BB74E1") '||
                               'MERGE(@"SEL$2" >"SEL$1") '||
                               'OUTLINE(@"SEL$1") '||
                               'OUTLINE(@"SEL$2") '||
                               'NO_ACCESS(@"SEL$09FF82E3" "VW_GBC_10"@"SEL$67910E1A") '||
                               'INDEX(@"SEL$09FF82E3" "C"@"SEL$1" ("CUSTOMERS"."CUST_ID")) '||
                               'LEADING(@"SEL$09FF82E3" "VW_GBC_10"@"SEL$67910E1A" "C"@"SEL$1") '||
                               'USE_NL(@"SEL$09FF82E3" "C"@"SEL$1") '||
                               'NLJ_BATCHING(@"SEL$09FF82E3" "C"@"SEL$1") '||
                               'USE_HASH_AGGREGATION(@"SEL$09FF82E3") '||
                               'FULL(@"SEL$C1C92257" "CH"@"SEL$2") '||
                               'BITMAP_TREE(@"SEL$C1C92257" "S"@"SEL$1" AND(("SALES"."CHANNEL_ID"))) '||
                               'LEADING(@"SEL$C1C92257" "CH"@"SEL$2" "S"@"SEL$1") '||
                               'USE_NL(@"SEL$C1C92257" "S"@"SEL$1") '||
                               'NLJ_BATCHING(@"SEL$C1C92257" "S"@"SEL$1") '||
                               'USE_HASH_AGGREGATION(@"SEL$C1C92257") ',
                   name      =>'sql_fc25kvvvb1aar_patch');
END;
/
-- end of patch block

```

# END