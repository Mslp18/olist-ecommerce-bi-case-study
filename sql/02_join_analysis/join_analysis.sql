-- Q1 Top Revenue Generating States

SELECT c.customer_state,
       ROUND(SUM(p.payment_value)::numeric, 2) AS total_revenue
FROM customers c
JOIN orders o
     ON c.customer_id = o.customer_id
JOIN payments p
     ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC
LIMIT 10;

-- Top Revenue States:
-- SP : 5,998,226.96
-- RJ : 2,144,379.69
-- MG : 1,872,257.26
-- RS :   890,898.54
-- PR :   811,156.38

-- Q2 States with Highest Average Order Value

SELECT c.customer_state,
       ROUND(
           AVG(p.payment_value)::numeric,
           2
       ) AS avg_order_value
FROM customers c
JOIN orders o
     ON c.customer_id = o.customer_id
JOIN payments p
     ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY avg_order_value DESC
LIMIT 10;

-- Highest Average Order Values:
-- PB : 248.33
-- AC : 234.29
-- RO : 233.20
-- AP : 232.33
-- AL : 227.08

-- Top Revenue Categories:
-- cama_mesa_banho : 1,712,553.67
-- beleza_saude : 1,657,373.12
-- informatica_acessorios : 1,585,330.45
-- moveis_decoracao : 1,430,176.39
-- relogios_presentes : 1,429,216.68

-- Q4 Categories with Highest Average Revenue Per Order

SELECT p.product_category_name,
       ROUND(
           AVG(pay.payment_value)::numeric,
           2
       ) AS avg_order_value
FROM products p
JOIN order_items oi
     ON p.product_id = oi.product_id
JOIN payments pay
     ON oi.order_id = pay.order_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(*) >= 100
ORDER BY avg_order_value DESC
LIMIT 10;

-- Highest Average Order Value Categories:
-- pcs : 1,268.73
-- telefonia_fixa : 763.88
-- agro_industria_e_comercio : 471.15
-- eletrodomesticos_2 : 464.79
-- moveis_escritorio : 363.79

-- Q5 Categories with Highest Customer Ratings

SELECT p.product_category_name,
       ROUND(
           AVG(r.review_score)::numeric,
           2
       ) AS avg_review_score
FROM products p
JOIN order_items oi
     ON p.product_id = oi.product_id
JOIN reviews r
     ON oi.order_id = r.order_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(*) >= 100
ORDER BY avg_review_score DESC
LIMIT 10;

-- Highest Rated Categories:
-- livros_interesse_geral : 4.45
-- livros_tecnicos : 4.37
-- malas_acessorios : 4.32
-- alimentos_bebidas : 4.32
-- fashion_calcados : 4.23

-- Q6 Categories with Lowest Customer Ratings

SELECT p.product_category_name,
       ROUND(
           AVG(r.review_score)::numeric,
           2
       ) AS avg_review_score
FROM products p
JOIN order_items oi
     ON p.product_id = oi.product_id
JOIN reviews r
     ON oi.order_id = r.order_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(*) >= 100
ORDER BY avg_review_score ASC
LIMIT 10;

-- Lowest Rated Categories:
-- moveis_escritorio : 3.49
-- fashion_roupa_masculina : 3.64
-- telefonia_fixa : 3.68
-- audio : 3.83
-- casa_conforto : 3.83

-- Q7 Top Revenue Generating Sellers

SELECT s.seller_id,
       ROUND(
           SUM(pay.payment_value)::numeric,
           2
       ) AS total_revenue
FROM sellers s
JOIN order_items oi
     ON s.seller_id = oi.seller_id
JOIN payments pay
     ON oi.order_id = pay.order_id
GROUP BY s.seller_id
ORDER BY total_revenue DESC
LIMIT 10;

-- Result:
-- Top seller revenue : 507,166.91
-- Revenue among top sellers ranges from 185,134.21 to 507,166.91

-- Q8 Sellers with Highest Order Volume

SELECT seller_id,
       COUNT(DISTINCT order_id) AS total_orders
FROM order_items
GROUP BY seller_id
ORDER BY total_orders DESC
LIMIT 10;

-- Result:
-- Highest order volume seller : 1,854 orders
-- Top 10 sellers processed between 1,080 and 1,854 orders

-- Q9 Categories with Highest Order Volume

SELECT p.product_category_name,
       COUNT(DISTINCT oi.order_id) AS total_orders
FROM products p
JOIN order_items oi
     ON p.product_id = oi.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
ORDER BY total_orders DESC
LIMIT 10;

-- Highest Order Volume Categories:
-- cama_mesa_banho : 9,417
-- beleza_saude : 8,836
-- esporte_lazer : 7,720
-- informatica_acessorios : 6,689
-- moveis_decoracao : 6,449

-- Q10 Revenue Concentration by Top States

SELECT ROUND(
       (
           SUM(total_revenue) * 100.0 /
           (
               SELECT SUM(payment_value)
               FROM payments
           )
       )::numeric,
       2
) AS top_10_state_revenue_share
FROM (
       SELECT SUM(p.payment_value) AS total_revenue
       FROM customers c
       JOIN orders o
            ON c.customer_id = o.customer_id
       JOIN payments p
            ON o.order_id = p.order_id
       GROUP BY c.customer_state
       ORDER BY total_revenue DESC
       LIMIT 10
     ) t;

-- Result: 87.38%