
ALTER TABLE mart.f_sales ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'shipped';

UPDATE mart.f_sales 
SET status = 'shipped' 
WHERE status IS NULL;

ALTER TABLE staging.user_order_log ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'shipped';