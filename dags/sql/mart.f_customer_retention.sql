delete from mart.f_customer_retention 
where period_id = (select week_of_year from mart.d_calendar where date_actual = '{{ ds }}'::date)
and period_name = 'weekly';

with user_orders as ( 
    select 
        fs.customer_id, 
        fs.item_id, 
        dc.week_of_year as period_id, 
        count(distinct case when fs.status = 'shipeed'then fs.payment_amount end) as orders_count, 
        sum(case when fs.status = 'shipped' then fs.payment_amount else 0 end) as total_revenue, 
        count(case when fs.status ='refunded' then 1 end) as refunds_count 
    from mart.f_sales fs 
    join mart.d_calendar dc on fs.date_id = dc.date_id 
    where dc.week_of_year = (select week_of_year from mart.d_calendar where date_actual = '{{ ds }}'::date)
    group by fs.customer_id, fs.item_id, dc.week_of_year
)
insert into mart.f_customer_retention (
    new_customers_count,
    returning_customers_count,
    refunded_customer_count,
    period_name,
    period_id,
    item_id,
    new_customers_revenue,
    returning_customers_revenue,
    customers_refunded
)
select
    COUNT(distinct case when orders_count = 1 then customer_id end) as new_customers_count,
    COUNT(distinct case when orders_count > 1 then customer_id end) as returning_customers_count,
    COUNT(distinct case whenN refunds_count > 0 then customer_id end) as refunded_customer_count,
    'weekly' as period_name,
    period_id,
    item_id,
    sum(case when orders_count = 1 then total_revenue else 0 end) as new_customers_revenue,
    sum(case when orders_count > 1 then total_revenue else 0 end) as returning_customers_revenue,
    sum(refunds_count) as customers_refunded
from user_orders
group by period_id, item_id;