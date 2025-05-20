/* orders_q2.sql */

/*
 This example will go through the steps of an adaptive plan that
 uses query executioj statistics feedback to adjust the plan between runs.
*/

PROMPT ========================== Adaptive SQL statistics feedback ==================================
PROMPT
PROMPT "First we purge the cursor and then the first run should be inefficent"
PROMPT

-- first we purge the cursor to make sure it is not in cache.
@@purge-cursor.sql c7db4mrf05vtx

-- now re-connect and run the query
@@connect.sql

SELECT count(1) FROM (
SELECT /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */
       o.order_id, v.product_name
  FROM oe.orders o,
       (  SELECT order_id, product_name
          FROM   oe.order_items o, oe.product_information p
          WHERE  p.product_id = o.product_id
          AND    list_price < 50
          AND    min_price < 40  ) v
  WHERE o.order_id = v.order_id);

-- now look at the plan and see how it does nested loops
@@plans.sql
@@cursors.sql c7db4mrf05vtx

PROMPT "For each query run look at the execution plan and the status in "
PROMPT "  v$sql for is_bind_aware, and buffer_gets"
PROMPT
PROMPT "=== The first run uses nested loops and has a large number of buffer gets"
PROMPT "===  and marked as is_reoptimizable as yes."

-- now lets run it agaih and see that statistics feedback is used
SELECT count(1) FROM (
SELECT /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */
       o.order_id, v.product_name
  FROM oe.orders o,
       (  SELECT order_id, product_name
          FROM   oe.order_items o, oe.product_information p
          WHERE  p.product_id = o.product_id
          AND    list_price < 50
          AND    min_price < 40  ) v
  WHERE o.order_id = v.order_id);

-- now look at the plan and see how it does nested loops
@@plans.sql
@@cursors.sql c7db4mrf05vtx

PROMPT
PROMPT "=== The second run uses statistcs feedback, this is in the notest part of "
PROMPT "===   the plan, as well as the reduced buffer gets and the new plan is    "
PROMPT "===   marked as is_reoptimizable no."



