-- ==========================================
-- DATABASE FIXES
-- ==========================================

-- Project: Olist E-Commerce BI Case Study
-- Purpose:
-- Fix incorrect datetime datatypes after PostgreSQL data load
-- and validate analytical readiness.

-- ==========================================
-- ORDERS TABLE DATETIME FIXES
-- ==========================================

ALTER TABLE orders
ALTER COLUMN order_purchase_timestamp TYPE TIMESTAMP
USING order_purchase_timestamp::timestamp;

ALTER TABLE orders
ALTER COLUMN order_approved_at TYPE TIMESTAMP
USING order_approved_at::timestamp;

ALTER TABLE orders
ALTER COLUMN order_delivered_carrier_date TYPE TIMESTAMP
USING order_delivered_carrier_date::timestamp;

ALTER TABLE orders
ALTER COLUMN order_delivered_customer_date TYPE TIMESTAMP
USING order_delivered_customer_date::timestamp;

ALTER TABLE orders
ALTER COLUMN order_estimated_delivery_date TYPE TIMESTAMP
USING order_estimated_delivery_date::timestamp;

-- ==========================================
-- VALIDATION
-- ==========================================

SELECT column_name,
       data_type
FROM information_schema.columns
WHERE table_name = 'orders'
ORDER BY ordinal_position;

-- Expected Result:
-- order_purchase_timestamp      -> timestamp
-- order_approved_at             -> timestamp
-- order_delivered_carrier_date  -> timestamp
-- order_delivered_customer_date -> timestamp
-- order_estimated_delivery_date -> timestamp