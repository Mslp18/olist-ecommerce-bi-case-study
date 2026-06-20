-- KPI 1 Total Revenue

SELECT ROUND(
       SUM(payment_value)::numeric,
       2
) AS total_revenue
FROM payments;

-- Result: 16,008,872.12


-- KPI 2 Total Orders

SELECT COUNT(*) AS total_orders
FROM orders;

-- Result: 99,441


-- KPI 3 Total Customers

SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM customers;

-- Result: 96,096

-- KPI 4 Average Order Value 
SELECT ROUND(
       (
           SUM(payment_value) /
           COUNT(DISTINCT order_id)
       )::numeric,
       2
) AS average_order_value
FROM payments;

-- Result: 160.99


-- KPI 5 Average Review Score

SELECT ROUND(
       AVG(review_score)::numeric,
       2
) AS average_review_score
FROM reviews;

-- Result: 4.09


-- KPI 6 Revenue Per Customer

SELECT ROUND(
       (
           SELECT SUM(payment_value)
           FROM payments
       )::numeric /
       (
           SELECT COUNT(DISTINCT customer_unique_id)
           FROM customers
       ),
       2
) AS revenue_per_customer;

-- Result: 166.59

-- KPI 7 Orders Per Customer

SELECT ROUND(
       COUNT(*)::numeric /
       (
           SELECT COUNT(DISTINCT customer_unique_id)
           FROM customers
       ),
       2
) AS orders_per_customer
FROM orders;

-- Result: 1.03


-- KPI 8 Repeat Purchase Rate

SELECT ROUND(
       COUNT(*) * 100.0 /
       (
           SELECT COUNT(DISTINCT customer_unique_id)
           FROM customers
       ),
       2
) AS repeat_purchase_rate
FROM (
       SELECT customer_unique_id
       FROM customers
       GROUP BY customer_unique_id
       HAVING COUNT(*) > 1
     ) t;

-- Result: 3.12%


-- KPI 9 Delivery Success Rate

SELECT ROUND(
       COUNT(*) * 100.0 /
       (
           SELECT COUNT(*)
           FROM orders
       ),
       2
) AS delivery_success_rate
FROM orders
WHERE order_status = 'delivered';

-- Result: 97.02%


-- KPI 10 Five-Star Review Rate

SELECT ROUND(
       COUNT(*) * 100.0 /
       (
           SELECT COUNT(*)
           FROM reviews
       ),
       2
) AS five_star_review_rate
FROM reviews
WHERE review_score = 5;

-- Result: 57.78%