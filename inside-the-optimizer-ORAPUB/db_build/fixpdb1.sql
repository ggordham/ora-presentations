
create index sh.customers_prov on sh.customers(cust_state_province);
exec dbms_stats.gather_schema_stats('SH');

GRANT SELECT ON co.products TO perflab;
GRANT SELECT ON co.orders TO perflab;
GRANT SELECT ON co.order_items TO perflab;
GRANT SELECT ON co.stores TO perflab;

GRANT SELECT ON sh.customers TO perflab;
GRANT SELECT ON oe.order_items TO perflab;
GRANT SELECT ON oe.product_information TO perflab;

GRANT READ ON hr.departments TO perflab;
GRANT READ ON hr.employees TO perflab;
GRANT READ ON hr.jobs TO perflab;
GRANT READ ON hr.locations TO perflab;
GRANT READ ON hr.regions TO perflab;
GRANT READ ON hr.countries TO perflab;
GRANT READ ON hr.job_history TO perflab;

