-- ==========================================
-- ORDER EDA
-- ==========================================

-- Q1 Total Orders

SELECT COUNT(*) AS total_orders
FROM orders;

-- Result: 99,441

-- Q2 Order Status Distribution

SELECT order_status,
       COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Result:
-- delivered : 96,478
-- shipped : 1,107
-- canceled : 625
-- unavailable : 609
-- invoiced : 314
-- processing : 301
-- created : 5
-- approved : 2

-- Q3 Delivered Orders Percentage

SELECT ROUND(
       COUNT(*) * 100.0 /
       (SELECT COUNT(*) FROM orders),
       2
) AS delivered_percentage
FROM orders
WHERE order_status = 'delivered';

-- Result: 97.02%

-- Q4 Canceled Orders Percentage

SELECT ROUND(
       COUNT(*) * 100.0 /
       (SELECT COUNT(*) FROM orders),
       2
) AS canceled_percentage
FROM orders
WHERE order_status = 'canceled';

-- Result: 0.63%

-- Q5 Orders by Year

SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS purchase_year,
       COUNT(*) AS total_orders
FROM orders
GROUP BY EXTRACT(YEAR FROM order_purchase_timestamp)
ORDER BY purchase_year;

-- Result:
-- 2016 : 329
-- 2017 : 45,101
-- 2018 : 54,011

-- Q6 Orders by Month

SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS purchase_year,
       EXTRACT(MONTH FROM order_purchase_timestamp) AS purchase_month,
       COUNT(*) AS total_orders
FROM orders
GROUP BY EXTRACT(YEAR FROM order_purchase_timestamp),
         EXTRACT(MONTH FROM order_purchase_timestamp)
ORDER BY purchase_year, purchase_month;

-- Q7 Peak Order Month

SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS purchase_year,
       EXTRACT(MONTH FROM order_purchase_timestamp) AS purchase_month,
       COUNT(*) AS total_orders
FROM orders
GROUP BY EXTRACT(YEAR FROM order_purchase_timestamp),
         EXTRACT(MONTH FROM order_purchase_timestamp)
ORDER BY total_orders DESC
LIMIT 1;

-- Result:
-- Nov 2017 : 7,544 orders

-- Q8 Orders by Weekday

SELECT TO_CHAR(order_purchase_timestamp, 'Day') AS weekday,
       COUNT(*) AS total_orders
FROM orders
GROUP BY weekday
ORDER BY total_orders DESC;

-- Result:
-- Monday    : 16,196
-- Tuesday   : 15,963
-- Wednesday : 15,552
-- Thursday  : 14,761
-- Friday    : 14,122
-- Sunday    : 11,960
-- Saturday  : 10,887

-- Q9 Average Orders Per Day

SELECT ROUND(
       COUNT(*) * 1.0 /
       COUNT(DISTINCT DATE(order_purchase_timestamp)),
       2
) AS avg_orders_per_day
FROM orders;

-- Result: 156.85 orders per day

-- Q10 Monthly Order Growth Trend

SELECT EXTRACT(YEAR FROM order_purchase_timestamp) AS purchase_year,
       EXTRACT(MONTH FROM order_purchase_timestamp) AS purchase_month,
       COUNT(*) AS total_orders,
       LAG(COUNT(*)) OVER (
           ORDER BY EXTRACT(YEAR FROM order_purchase_timestamp),
                    EXTRACT(MONTH FROM order_purchase_timestamp)
       ) AS previous_month_orders
FROM orders
GROUP BY EXTRACT(YEAR FROM order_purchase_timestamp),
         EXTRACT(MONTH FROM order_purchase_timestamp)
ORDER BY purchase_year, purchase_month;

-- Key Findings:
-- Strong growth throughout 2017
-- Peak month: Nov 2017 (7,544 orders)
-- Stable volume throughout 2018
-- Sep 2018 and Oct 2018 contain incomplete data