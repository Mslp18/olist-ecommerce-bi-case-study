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
-- REVIEWS TABLE DATATYPE FIXES
-- ==========================================

ALTER TABLE reviews
ALTER COLUMN review_creation_date
TYPE TIMESTAMP
USING review_creation_date::timestamp;

ALTER TABLE reviews
ALTER COLUMN review_answer_timestamp
TYPE TIMESTAMP
USING review_answer_timestamp::timestamp;

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

-- ==========================================
-- ORDER ITEMS TABLE DATATYPE FIXES
-- ==========================================

ALTER TABLE order_items
ALTER COLUMN shipping_limit_date
TYPE TIMESTAMP
USING shipping_limit_date::timestamp;