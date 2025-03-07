/*
===============================================================================
Product Performance Analysis (Year-over-Year)
===============================================================================
Purpose:
    - To analyze product sales performance year over year.
    - To compare current year sales to the product's average sales and the 
      previous year's sales.
    - To identify trends and growth patterns.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/


/* 
-----------------------------------------------------------------------------------
Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales 
-----------------------------------------------------------------------------------
*/

WITH yearly_product_sales AS (
    SELECT
        EXTRACT(YEAR FROM f.order_date) AS sales_year,  
        p.product_name,
        SUM(f.sales_amount) AS current_year_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY sales_year, p.product_name
)
SELECT
    sales_year,
    product_name,
    current_year_sales,
    ROUND(AVG(current_year_sales) OVER (PARTITION BY product_name), 2) AS average_sales,
    ROUND(current_year_sales - AVG(current_year_sales) OVER (PARTITION BY product_name), 2) AS difference_from_average,  
    CASE
        WHEN current_year_sales > AVG(current_year_sales) OVER (PARTITION BY product_name) THEN 'Above Average 🟢'
        WHEN current_year_sales < AVG(current_year_sales) OVER (PARTITION BY product_name) THEN 'Below Average 🔴'
        ELSE 'Average 🟡'
    END AS average_sales_performance,  
    LAG(current_year_sales) OVER (PARTITION BY product_name ORDER BY sales_year) AS previous_year_sales,  
    ROUND(current_year_sales - LAG(current_year_sales) OVER (PARTITION BY product_name ORDER BY sales_year), 2) AS year_over_year_difference,  
    CASE
        WHEN current_year_sales > LAG(current_year_sales) OVER (PARTITION BY product_name ORDER BY sales_year) THEN 'Increase ⬆️' 
        WHEN current_year_sales < LAG(current_year_sales) OVER (PARTITION BY product_name ORDER BY sales_year) THEN 'Decrease ⬇️'
        ELSE 'No Change ⏸️'
    END AS year_over_year_change  
FROM yearly_product_sales
ORDER BY product_name, sales_year;