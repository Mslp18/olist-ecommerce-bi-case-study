-- ==========================================
-- CUSTOMER EDA
-- ==========================================

-- Q1 Total Customer Records

SELECT COUNT(*)
FROM customers;

-- Result: 99,441


-- Q2 Unique Customers

SELECT COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;

-- Result: 96,096


-- Q3 Top 7 States by Customer Count

SELECT customer_state,
       COUNT(DISTINCT customer_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 7;

-- Result:
-- SP : 41,746
-- RJ : 12,852
-- MG : 11,635
-- RS : 5,466
-- PR : 5,045
-- SC : 3,637
-- BA : 3,380

-- Q4 Top 7 Cities by Customer Count

SELECT customer_city,
       COUNT(DISTINCT customer_id) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 7;

-- Result:
-- sao paulo    : 15,540
-- rio de janeiro : 6,882
-- belo horizonte : 2,773
-- brasilia : 2,131
-- curitiba : 1,521
-- campinas : 1,444
-- porto alegre : 1,379

-- Q5 States with Lowest Customer Count

SELECT customer_state,
       COUNT(DISTINCT customer_id) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers ASC
LIMIT 7;

-- Result:
-- RR : 46
-- AP : 68
-- AC : 81
-- AM : 148
-- RO : 253
-- TO : 280
-- SE : 350

-- Q6 Customer Distribution by State (%)

SELECT customer_state,
       COUNT(DISTINCT customer_id) AS total_customers,
       ROUND(
           COUNT(DISTINCT customer_id) * 100.0 /
           (SELECT COUNT(DISTINCT customer_id) FROM customers),
           2
       ) AS customer_percentage
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC
LIMIT 10;

-- Result:
-- SP : 41,746 (41.98%)
-- RJ : 12,852 (12.92%)
-- MG : 11,635 (11.70%)
-- RS : 5,466 (5.50%)
-- PR : 5,045 (5.07%)
-- SC : 3,637 (3.66%)
-- BA : 3,380 (3.40%)
-- DF : 2,140 (2.15%)
-- ES : 2,033 (2.04%)
-- GO : 2,020 (2.03%)

-- Q7 Repeat Customers

SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT customer_unique_id
    FROM customers
    GROUP BY customer_unique_id
    HAVING COUNT(*) > 1
) t;

-- Result: 2,997

-- Q8 Repeat Customer Percentage

SELECT ROUND(
       COUNT(*) * 100.0 /
       (SELECT COUNT(DISTINCT customer_unique_id) FROM customers),
       2
) AS repeat_customer_percentage
FROM (
    SELECT customer_unique_id
    FROM customers
    GROUP BY customer_unique_id
    HAVING COUNT(*) > 1
) t;

-- Result: 3.12%

-- Q9 Cities with Highest Customer Concentration

SELECT customer_city,
       COUNT(DISTINCT customer_id) AS total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 10;

-- Result:
-- sao paulo : 15,540
-- rio de janeiro : 6,882
-- belo horizonte : 2,773
-- brasilia : 2,131
-- curitiba : 1,521
-- campinas : 1,444
-- porto alegre : 1,379
-- salvador : 1,245
-- guarulhos : 1,189
-- sao bernardo do campo : 938

-- Q10 Marketplace Geographic Coverage

SELECT COUNT(DISTINCT customer_city) AS total_cities
FROM customers;

-- Result: 4,119