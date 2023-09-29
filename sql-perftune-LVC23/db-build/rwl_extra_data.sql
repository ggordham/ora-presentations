
DECLARE
  v_num_days number;
  v_num_future number;
  v_future_offset number;

BEGIN
  v_num_days := 80;
  v_num_future := 12;
  v_future_offset := 200000000;

  -- create more historical orders for the RWL schema.
  FOR v_i IN 1 .. v_num_days
  LOOP
    INSERT INTO rwloe.orders
        SELECT order_id + (100000 * v_i), order_date - (v_i + 1),
               customer_id, order_status, order_total
           FROM rwloe.orders
          WHERE order_id < 10000;
    COMMIT;
    INSERT INTO rwloe.order_items
        SELECT order_id + (100000 * v_i), line_item_id, product_id,
               unit_price, quantity
           FROM rwloe.order_items
          WHERE order_id < 10000;
    COMMIT;
  END LOOP;

  -- Make some future orders for the RWL schema to throw the optimizer estimates off
  FOR v_i IN 1 .. v_num_future
  LOOP
    INSERT INTO rwloe.orders
        SELECT order_id + (10000000 * v_i) + v_future_offset, order_date + (2 * v_num_days) + v_i,
               customer_id, order_status, order_total
           FROM rwloe.orders
          WHERE order_id < 10000;
    COMMIT;
    INSERT INTO rwloe.order_items
        SELECT order_id + (10000000 * v_i) + v_future_offset, line_item_id, product_id,
               unit_price, quantity
           FROM rwloe.order_items
          WHERE order_id < 10000;
    COMMIT;
  END LOOP;
END;
/

-- Update older orders to shipped
DECLARE
  v_pct_age NUMBER;
  v_days_old NUMBER;
  v_oldest_order DATE;
BEGIN
    v_pct_age := 60;

    -- find oldest order
    SELECT MIN(order_date) INTO v_oldest_order FROM rwloe.orders;

    -- figure out how many days back to go
    v_days_old := (SYSDATE - v_oldest_order) * (1/(100 - v_pct_age));

    UPDATE rwloe.orders
       SET order_status = 'shipped'
       WHERE order_date < (SYSDATE - v_days_old);

    COMMIT;
END;
/

CREATE INDEX rwloe.orders_ix2 ON rwloe.orders(order_date);

CREATE INDEX rwloe.products_ix2 ON rwloe.products(product_status);

exec dbms_stats.gather_table_stats('RWLOE', 'ORDERS', method_opt=>'for all columns size 1')
exec dbms_stats.gather_table_stats('RWLOE', 'ORDER_ITEMS', method_opt=>'for all columns size 1')

/* 
-- cleanup
delete from rwloe.order_items where order_id > 99999;

delete from rwloe.orders where order_id > 99999;

commit;
*/
