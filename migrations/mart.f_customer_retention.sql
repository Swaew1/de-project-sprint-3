CREATE TABLE IF NOT EXISTS mart.f_customer_retention (
    new_customers_count int, 
    returning_customers_count int, 
    refunded_customer_count int, 
    period_name varchar(10) default 'weekly', 
    period_id int, 
    item_id int, 
    new_customers_revenue numeric(14,2),
    returning_customers_revenue numeric(14,2), 
    customers_refunded int, 
    primary key (period_id, item_id)
);

