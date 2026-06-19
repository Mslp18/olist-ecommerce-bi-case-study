-- ==========================================
-- PRODUCT EDA
-- ==========================================

-- Q1 Total Products

SELECT COUNT(*) AS total_products
FROM products;

-- Result: 32,951

-- Q2 Total Product Categories

SELECT COUNT(DISTINCT product_category_name) AS total_categories
FROM products;

-- Result: 73 categories

-- Q3 Top Categories by Product Count

SELECT product_category_name,
       COUNT(*) AS total_products
FROM products
WHERE product_category_name IS NOT NULL
GROUP BY product_category_name
ORDER BY total_products DESC
LIMIT 10;

-- Top Categories:
-- cama_mesa_banho      : 3,029
-- esporte_lazer        : 2,867
-- moveis_decoracao     : 2,657
-- beleza_saude         : 2,444
-- utilidades_domesticas: 2,335
-- automotivo           : 1,900
-- informatica_acessorios: 1,639

-- Q4 Smallest Categories by Product Count

SELECT product_category_name,
       COUNT(*) AS total_products
FROM products
WHERE product_category_name IS NOT NULL
GROUP BY product_category_name
ORDER BY total_products ASC
LIMIT 10;

-- Smallest Categories:
-- cds_dvds_musicais : 1
-- seguros_e_servicos : 2
-- pc_gamer : 3
-- fashion_roupa_infanto_juvenil : 5
-- casa_conforto_2 : 5
-- tablets_impressao_imagem : 9

-- Q5 Average Product Weight

SELECT ROUND(
       AVG(product_weight_g)::numeric,
       2
) AS avg_product_weight
FROM products
WHERE product_weight_g IS NOT NULL;

-- Result: 2,276.47 grams

-- Q6 Average Product Dimensions

SELECT ROUND(AVG(product_length_cm)::numeric, 2) AS avg_length_cm,
       ROUND(AVG(product_height_cm)::numeric, 2) AS avg_height_cm,
       ROUND(AVG(product_width_cm)::numeric, 2) AS avg_width_cm
FROM products
WHERE product_length_cm IS NOT NULL;

-- Result:
-- Average Length : 30.82 cm
-- Average Height : 16.94 cm
-- Average Width  : 23.20 cm

-- Q7 Categories with Highest Average Product Weight

SELECT product_category_name,
       ROUND(AVG(product_weight_g)::numeric, 2) AS avg_weight_g
FROM products
WHERE product_category_name IS NOT NULL
  AND product_weight_g IS NOT NULL
GROUP BY product_category_name
HAVING COUNT(*) >= 10
ORDER BY avg_weight_g DESC
LIMIT 10;

-- Key Findings:
-- moveis_colchao_e_estofado : 13,190 g
-- moveis_escritorio : 12,740.87 g
-- moveis_cozinha_area_de_servico_jantar_e_jardim : 11,598.56 g
-- moveis_quarto : 9,997.22 g
-- eletrodomesticos_2 : 9,913.33 g

-- Q8 Largest Product Catalog Share

SELECT product_category_name,
       COUNT(*) AS total_products,
       ROUND(
           COUNT(*) * 100.0 /
           (SELECT COUNT(*) FROM products),
           2
       ) AS catalog_share_percentage
FROM products
WHERE product_category_name IS NOT NULL
GROUP BY product_category_name
ORDER BY total_products DESC
LIMIT 10;

-- Key Findings:
-- cama_mesa_banho : 9.19%
-- esporte_lazer : 8.70%
-- moveis_decoracao : 8.06%
-- beleza_saude : 7.42%
-- utilidades_domesticas : 7.09%

-- Q9 Product Catalog Concentration

SELECT ROUND(
       SUM(category_count) * 100.0 /
       (SELECT COUNT(*) FROM products),
       2
) AS top_10_catalog_share
FROM (
       SELECT COUNT(*) AS category_count
       FROM products
       WHERE product_category_name IS NOT NULL
       GROUP BY product_category_name
       ORDER BY category_count DESC
       LIMIT 10
     ) t;

-- Result: 62.96%

-- Q10 Products with Missing Category Information

SELECT COUNT(*) AS products_without_category
FROM products
WHERE product_category_name IS NULL;

-- Result:
-- Products without category : 610
-- Percentage of catalog : 1.85%