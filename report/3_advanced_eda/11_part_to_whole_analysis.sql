/*
===============================================================================
Part-to-Whole Analysis (PostgreSQL)
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

-- 1. Which categories contribute the most to overall sales?

WITH product_cost_segments AS (
    SELECT
        product_key,
        product_name,
        product_cost,
        CASE
            WHEN product_cost < 100 THEN 'Below 100'
            WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)
SELECT
    cost_range,
    COUNT(product_key) AS total_products
FROM product_cost_segments
GROUP BY cost_range
ORDER BY total_products DESC;


-- 2. Category contribution to overall sales

WITH category_sales AS (
    SELECT
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,  -- Calculate overall sales
    ROUND((total_sales * 100.0 / SUM(total_sales) OVER ()), 2) || '%' AS percentage_of_total
FROM category_sales
ORDER BY percentage_of_total DESC;



-- 3. Sales contribution by region 
WITH region_sales AS (
    SELECT
        c.country AS region,  -- Or whatever your regional column is named
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
    GROUP BY c.country -- Grouping by the region
)
SELECT
    region,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND((total_sales * 100.0 / SUM(total_sales) OVER ()), 2) || '%' AS percentage_of_total
FROM region_sales
ORDER BY percentage_of_total DESC;


--  4. Sales contribution by year
WITH yearly_sales AS (
    SELECT
        EXTRACT(YEAR FROM f.order_date) AS sales_year,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    GROUP BY sales_year
)
SELECT
    sales_year,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND((total_sales * 100.0 / SUM(total_sales) OVER ()), 2) || '%' AS percentage_of_total
FROM yearly_sales
ORDER BY sales_year;