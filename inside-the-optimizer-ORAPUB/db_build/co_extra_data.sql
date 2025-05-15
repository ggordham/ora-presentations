insert into co.customers
  values (5001,'sales@megawarehouse.inc','MEGA Warehouse Inc');

insert into co.orders
  select order_id+50000, order_datetime, 5001, order_status, store_id
    FROM co.orders;

insert into co.shipments
  SELECT shipment_id+50000, store_id, 5001, 'Mega, TX 77435 USA', shipment_status
FROM co.shipments;

insert into co.order_items
  SELECT order_id+50000, line_item_id, product_id, unit_price,
         quantity, shipment_id+50000
    FROM co.order_items;

EXEC DBMS_STATS.GATHER_SCHEMA_STATS(ownname => 'CO');
