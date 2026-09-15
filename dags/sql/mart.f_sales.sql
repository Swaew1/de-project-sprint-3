INSERT INTO mart.f_sales (date_id, item_id, customer_id, city_id, quantity, payment_amount, status)
SELECT 
    dc.date_id, 
    uol.item_id, 
    uol.customer_id, 
    uol.city_id, 
    CASE WHEN COALESCE(uol.status, 'shipped') = 'refunded' THEN -ABS(uol.quantity) ELSE uol.quantity END AS quantity,
    CASE WHEN COALESCE(uol.status, 'shipped') = 'refunded' THEN -ABS(uol.payment_amount) ELSE uol.payment_amount END AS payment_amount,
    COALESCE(uol.status, 'shipped') AS status
FROM staging.user_order_log uol
LEFT JOIN mart.d_calendar AS dc ON uol.date_time::Date = dc.date_actual
WHERE uol.date_time::Date = '{{ ds }}';