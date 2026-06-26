-- ==========================================
-- PAYMENT EDA
-- ==========================================

-- Q1 Total Revenue Generated

SELECT ROUND(SUM(payment_value)::numeric, 2) AS total_revenue
FROM payments;

-- Result: 16,008,872.12

-- Q2 Average Order Value

SELECT ROUND(
       AVG(order_total)::numeric,
       2
) AS average_order_value
FROM (
       SELECT order_id,
              SUM(payment_value) AS order_total
       FROM payments
       GROUP BY order_id
     ) t;

-- Result: 160.99

-- Q3 Revenue by Payment Method

SELECT payment_type,
       ROUND(SUM(payment_value)::numeric, 2) AS total_revenue
FROM payments
GROUP BY payment_type
ORDER BY total_revenue DESC;

-- Result:
-- credit_card : 12,542,084.19
-- boleto      : 2,869,361.27
-- voucher     :   379,436.87
-- debit_card  :   217,989.79


-- Q4 Most Frequently Used Payment Method

SELECT payment_type,
       COUNT(*) AS total_transactions
FROM payments
GROUP BY payment_type
ORDER BY total_transactions DESC;

-- Result:
-- credit_card : 76,795
-- boleto      : 19,784
-- voucher     : 5,775
-- debit_card  : 1,529

-- Q5 Average Installments

SELECT ROUND(
       AVG(payment_installments)::numeric,
       2
) AS avg_installments
FROM payments;

-- Result: 2.85 installments

-- Q6 Percentage of Installment Payments

SELECT ROUND(
       COUNT(*) * 100.0 /
       (SELECT COUNT(*) FROM payments),
       2
) AS installment_percentage
FROM payments
WHERE payment_installments > 1;

-- Result: 49.42%

-- Q7 Credit Card Revenue Share

SELECT ROUND(
       (
           SUM(
               CASE
                   WHEN payment_type = 'credit_card'
                   THEN payment_value
                   ELSE 0
               END
           ) * 100.0 /
           SUM(payment_value)
       )::numeric,
       2
) AS credit_card_revenue_share
FROM payments;

-- Result: 78.34%

-- Q8 Installment Usage Distribution

SELECT payment_installments,
       COUNT(*) AS total_payments
FROM payments
GROUP BY payment_installments
ORDER BY total_payments DESC
LIMIT 10;

-- Key Findings:
-- 1 installment : 52,546 payments
-- 2 installments : 12,413 payments
-- 3 installments : 10,461 payments
-- 4 installments : 7,098 payments
-- 5 installments : 5,239 payments
-- 10 installments : 5,328 payments

-- Q9 Top 10 Highest Value Orders

SELECT order_id,
       ROUND(SUM(payment_value)::numeric, 2) AS order_value
FROM payments
GROUP BY order_id
ORDER BY order_value DESC
LIMIT 10;

-- Key Findings:
-- Highest Order Value : 13,664.08
-- Top 10 order values range from 4,681.78 to 13,664.08
-- Significant gap exists between average order value and premium purchases

-- Q10 Revenue Concentration Analysis

SELECT ROUND(
       SUM(order_value)::numeric,
       2
) AS top_10_order_revenue
FROM (
       SELECT SUM(payment_value) AS order_value
       FROM payments
       GROUP BY order_id
       ORDER BY order_value DESC
       LIMIT 10
     ) t;

-- Result: 66,804.58