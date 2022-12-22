
-- looks at all data, so not much to tune on this one
with order_totals as (
  select extract ( year from o.order_datetime ) order_year,
         to_char ( o.order_datetime, 'MON', 'NLS_DATE_LANGUAGE = english' ) order_month,
         sum ( oi.quantity * oi.unit_price ) value_of_orders
  from   co.orders o
  join   co.order_items oi
  on     o.order_id = oi.order_id
  group  by extract ( year from o.order_datetime ),
         to_char ( o.order_datetime, 'MON', 'NLS_DATE_LANGUAGE = english' )
)
  select * from order_totals
  pivot (
    sum ( value_of_orders ) value
    for order_month in (
      'JAN' JAN, 'FEB' FEB, 'MAR' MAR, 'APR' APR, 'MAY' MAY, 'JUN' JUN,
      'JUL' JUL, 'AUG' AUG, 'SEP' SEP, 'OCT' OCT, 'NOV' NOV, 'DEC' DEC
    )
  )
  order by order_year
/

-- Uses windowing function on full table to get to limited rowset
select p.product_name, 
       count(*) number_of_orders,
       sum ( oi.quantity * oi.unit_price ) total_value,
       rank () over ( 
         order by count(*) desc 
       ) order_count_rank
from   co.products p
join   co.order_items oi
on     p.product_id = oi.product_id
group  by p.product_name
order  by sum ( oi.quantity * oi.unit_price ) desc
fetch  first 5 rows only;

-- JSON lookup in nested loop becomes most expensive
with ratings as (
  select grouping_id ( product_name ) grp_id,
         product_name, 
         count(*) number_of_reviews,
         round ( avg ( rating ), 2 ) product_mean_rating,
         median ( rating ) product_median_rating,
         stats_mode ( rating ) product_mode_rating,
         min ( rating ) product_lowest_rating,
         max ( rating ) product_highest_rating
  from   co.products, json_table (
    product_details, '$.reviews[*]'
    columns (
      rating int path '$.rating'
    )
  )
  group  by rollup ( product_name )
)
  select /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */ case grp_id
           when 0 then product_name
           else 'TOTAL'
         end product_name,
         number_of_reviews,
         product_mean_rating,
         product_median_rating,
         product_mode_rating,
         product_lowest_rating,
         product_highest_rating
  from   co.ratings
  order  by grp_id, product_mean_rating desc;


with rws as (
  select 
         o.customer_id, trunc ( o.order_datetime, 'mm' ) order_month,
         sum ( oi.quantity * oi.unit_price ) month_total
  from   co.products p
  join   co.order_items oi
  on     p.product_id = oi.product_id
  join   co.orders o
  on     oi.order_id = o.order_id
  group  by o.customer_id, trunc ( o.order_datetime, 'mm' )
)
  select /*+ gather_plan_statistics NO_ADAPTIVE_PLAN */ * from rws 
  match_recognize (
    partition by customer_id
    order by order_month
    measures
      count(*) as num_months,
      sum ( month_total ) as total_value 
    pattern ( high_value consecutive{2,} )
    define
      high_value as 
        month_total >= 100,
      consecutive as 
        order_month = prev ( add_months ( order_month, 1 ) )
        and month_total >= 100
  );


with store_orders as (
  select store_name, trunc ( order_datetime ) dt, count(*) order#
  from   co.orders o
  join   co.stores s
  on     o.store_id = s.store_id
  group  by store_name, trunc ( order_datetime )
), consecutive_days as (
  select store_name, consecutive_days, 
         max ( consecutive_days ) over ( partition by store_name ) store_mx
  from   store_orders match_recognize (
    partition by store_name
    order by dt
    measures
      first ( dt ) as first_day,
      count (*)    as consecutive_days
    pattern ( init consecutive* )
    define 
      consecutive as dt <= prev ( dt ) + 1
  )
)
  select distinct *
  from   consecutive_days
  where  consecutive_days = store_mx
  order  by store_mx desc;
