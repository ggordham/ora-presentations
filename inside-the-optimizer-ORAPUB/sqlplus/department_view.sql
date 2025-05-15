/* department_view.sql */

/* 
  to show complex view merging 
*/

prompt "==========================================================================="
set echo on

SELECT /*+ NO_MERGE(dept_locs_v) */
       e.first_name, e.last_name, dept_locs_v.street_address,
       dept_locs_v.postal_code
FROM   hr.employees e,
      ( SELECT d.department_id, d.department_name, 
               l.street_address, l.postal_code
        FROM   hr.departments d, hr.locations l
        WHERE  d.location_id = l.location_id ) dept_locs_v
WHERE  dept_locs_v.department_id = e.department_id
AND    e.last_name = 'Smith';

@@planb.sql

prompt "note that the plan has the view listed"

set echo on
SELECT e.first_name, e.last_name, dept_locs_v.street_address,
       dept_locs_v.postal_code
FROM   hr.employees e,
      ( SELECT d.department_id, d.department_name, 
               l.street_address, l.postal_code
        FROM   hr.departments d, hr.locations l
        WHERE  d.location_id = l.location_id ) dept_locs_v
WHERE  dept_locs_v.department_id = e.department_id
AND    e.last_name = 'Smith';

@@planb.sql

prompt "note that the view is removed from the plan"

set echo on
SELECT e.first_name, e.last_name, l.street_address, l.postal_code
FROM   hr.employees e, hr.departments d, hr.locations l
WHERE  d.location_id = l.location_id
AND    d.department_id = e.department_id
AND    e.last_name = 'Smith';

@@planb.sql

prompt "note that this rewritten query without the view matches the previous merge query"

set echo off
prompt "==========================================================================="

