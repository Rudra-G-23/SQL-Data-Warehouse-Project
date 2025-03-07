/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.

SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- 1. Explore all distinct countries our customers come from.
SELECT
    DISTINCT country
FROM
    gold.dim_customers;

-- 2. Explore all distinct categories, subcategories, and product names.
SELECT
    DISTINCT category,
    subcategory,
    product_name  
FROM
    gold.dim_products
ORDER BY
    category, subcategory, product_name; 