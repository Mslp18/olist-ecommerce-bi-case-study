-- ==========================================
-- ADVANCED SQL ANALYSIS 1
-- Monthly Revenue Trend Analysis
-- ==========================================

WITH monthly_revenue AS
(
    SELECT
        purchase_year,
        purchase_month,
        ROUND(
              SUM(payment_value)::numeric,
              2
        ) AS revenue
    FROM orders o
    JOIN payments p
         ON o.order_id = p.order_id
    GROUP BY purchase_year,
             purchase_month
)

SELECT
       purchase_year,
       purchase_month,
       revenue,
       LAG(revenue) OVER(
           ORDER BY purchase_year,
                    purchase_month
       ) AS previous_month_revenue
FROM monthly_revenue
ORDER BY purchase_year,
         purchase_month;

-- Key Result:
-- Highest Revenue Month: March 2018
-- Revenue: 1,159,652.12
-- Previous Month Revenue: 992,463.34


-- ==========================================
-- ADVANCED SQL ANALYSIS 2
-- Revenue Growth Percentage Analysis
-- ==========================================

WITH monthly_revenue AS
(
    SELECT
        purchase_year,
        purchase_month,
        ROUND(
              SUM(payment_value)::numeric,
              2
        ) AS revenue
    FROM orders o
    JOIN payments p
         ON o.order_id = p.order_id
    GROUP BY purchase_year,
             purchase_month
)

SELECT
       purchase_year,
       purchase_month,
       revenue,
       LAG(revenue) OVER(
           ORDER BY purchase_year,
                    purchase_month
       ) AS previous_month_revenue,
       ROUND(
            (
                (
                    revenue -
                    LAG(revenue) OVER(
                        ORDER BY purchase_year,
                                 purchase_month
                    )
                ) * 100.0
            /
                LAG(revenue) OVER(
                    ORDER BY purchase_year,
                             purchase_month
                )
            )::numeric,
            2
       ) AS revenue_growth_percentage
FROM monthly_revenue
ORDER BY purchase_year,
         purchase_month;

-- Key Result:
-- Highest Meaningful Growth: February 2017 (+110.78%)
-- Largest Meaningful Decline: December 2017 (-26.49%)

-- ==========================================
-- ADVANCED SQL ANALYSIS 3
-- Seller Revenue Ranking
-- ==========================================

WITH seller_revenue AS
(
    SELECT
           s.seller_id,
           ROUND(
                 SUM(p.payment_value)::numeric,
                 2
           ) AS total_revenue
    FROM sellers s
    JOIN order_items oi
         ON s.seller_id = oi.seller_id
    JOIN payments p
         ON oi.order_id = p.order_id
    GROUP BY s.seller_id
)

SELECT
       seller_id,
       total_revenue,
       RANK() OVER(
           ORDER BY total_revenue DESC
       ) AS revenue_rank
FROM seller_revenue
ORDER BY revenue_rank
LIMIT 10;

-- Key Result:
-- Rank 1 Revenue: 507,166.91
-- Rank 2 Revenue: 308,222.04
-- Rank 3 Revenue: 301,245.27

-- ==========================================
-- ADVANCED SQL ANALYSIS 4
-- Product Category Revenue Ranking
-- ==========================================

WITH category_revenue AS
(
    SELECT
           p.product_category_name,
           ROUND(
                 SUM(pay.payment_value)::numeric,
                 2
           ) AS total_revenue
    FROM products p
    JOIN order_items oi
         ON p.product_id = oi.product_id
    JOIN payments pay
         ON oi.order_id = pay.order_id
    GROUP BY p.product_category_name
)

SELECT
       product_category_name,
       total_revenue,
       DENSE_RANK() OVER(
           ORDER BY total_revenue DESC
       ) AS category_rank
FROM category_revenue
ORDER BY category_rank
LIMIT 10;

-- Key Result:
-- Rank 1: Bed, Bath & Table (1,712,553.67)
-- Rank 2: Beauty & Health (1,657,373.12)
-- Rank 3: Computer Accessories (1,585,330.45)


-- ==========================================
-- ADVANCED SQL ANALYSIS 5
-- Cumulative Revenue Growth
-- ==========================================

WITH monthly_revenue AS
(
    SELECT
           purchase_year,
           purchase_month,
           ROUND(
                 SUM(payment_value)::numeric,
                 2
           ) AS revenue
    FROM orders o
    JOIN payments p
         ON o.order_id = p.order_id
    GROUP BY purchase_year,
             purchase_month
)

SELECT
       purchase_year,
       purchase_month,
       revenue,
       SUM(revenue) OVER(
           ORDER BY purchase_year,
                    purchase_month
       ) AS cumulative_revenue
FROM monthly_revenue
ORDER BY purchase_year,
         purchase_month;

-- Key Result:
-- Final Cumulative Revenue: 16,008,872.12

-- ==========================================
-- ADVANCED SQL ANALYSIS 6
-- Top Revenue Month by Year
-- ==========================================

WITH monthly_revenue AS
(
    SELECT
           purchase_year,
           purchase_month,
           ROUND(
                 SUM(payment_value)::numeric,
                 2
           ) AS revenue
    FROM orders o
    JOIN payments p
         ON o.order_id = p.order_id
    GROUP BY purchase_year,
             purchase_month
),

ranked_months AS
(
    SELECT
           purchase_year,
           purchase_month,
           revenue,
           ROW_NUMBER() OVER(
               PARTITION BY purchase_year
               ORDER BY revenue DESC
           ) AS rn
    FROM monthly_revenue
)

SELECT *
FROM ranked_months
WHERE rn = 1
ORDER BY purchase_year;

-- Key Result:
-- 2016 Best Month: October (59,090.48)
-- 2017 Best Month: November (1,194,882.80)
-- 2018 Best Month: April (1,160,785.48)

-- ==========================================
-- ADVANCED SQL ANALYSIS 7
-- Revenue Variance Analysis
-- ==========================================

WITH monthly_revenue AS
(
    SELECT
           purchase_year,
           purchase_month,
           ROUND(
                 SUM(payment_value)::numeric,
                 2
           ) AS revenue
    FROM orders o
    JOIN payments p
         ON o.order_id = p.order_id
    GROUP BY purchase_year,
             purchase_month
),

revenue_changes AS
(
    SELECT
           purchase_year,
           purchase_month,
           revenue,
           LAG(revenue) OVER(
               ORDER BY purchase_year,
                        purchase_month
           ) AS previous_revenue,
           revenue -
           LAG(revenue) OVER(
               ORDER BY purchase_year,
                        purchase_month
           ) AS revenue_change
    FROM monthly_revenue
)

SELECT *
FROM revenue_changes
ORDER BY ABS(revenue_change) DESC;

-- Key Result:
-- Largest Increase: November 2017 (+415,204.92)
-- Largest Decrease: December 2017 (-316,481.32)