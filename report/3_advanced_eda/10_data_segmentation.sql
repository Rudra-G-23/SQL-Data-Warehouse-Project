/*
===============================================================================
Data Segmentation Analysis (PostgreSQL)
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

-- 1. Segment products into product_cost ranges and count products in each segment.
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
        END AS product_cost_range
    FROM gold.dim_products
)
SELECT
    product_cost_range,
    COUNT(product_key) AS total_products
FROM product_cost_segments
GROUP BY product_cost_range
ORDER BY total_products DESC;


-----------------------------------------------------------------------------------
-- 2. Segment customers based on spending and tenure (lifespan).
--    - VIP: 12+ months tenure AND spending > €5,000.
--    - Regular: 12+ months tenure AND spending <= €5,000.
--    - New: < 12 months tenure.
-----------------------------------------------------------------------------------

WITH customer_spending AS (
    SELECT
        c.customer_key,
        c.first_name || ' ' || c.last_name AS full_name, 
        SUM(f.sales_amount) AS total_spending,
        MIN(f.order_date) AS first_order_date,
        MAX(f.order_date) AS last_order_date,
        -- Calculate lifespan in months.
		(EXTRACT(YEAR FROM AGE(MAX(f.order_date), MIN(f.order_date)))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(f.order_date), MIN(f.order_date))) AS lifespan_months
    FROM
        gold.fact_sales f
        LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
    GROUP BY c.customer_key, full_name
),
customer_segments AS (
    SELECT
        customer_key,
        full_name,
        total_spending,
        lifespan_months,
        CASE
            WHEN lifespan_months >= 12 AND total_spending > 5000 THEN 'VIP'
            WHEN lifespan_months >= 12 AND total_spending <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS customer_segment
    FROM customer_spending
)
SELECT
    customer_segment,
    COUNT(customer_key) AS number_of_customers
FROM customer_segments
GROUP BY customer_segment
ORDER BY number_of_customers DESC;


-- 3. Segment customers by country and calculate total spending per segment.
SELECT
    c.country,
    CASE
        WHEN SUM(f.sales_amount) > 1000000 THEN 'High Spending'
        ELSE 'Low Spending'
    END AS spending_segment,
    SUM(f.sales_amount) AS total_spending
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY c.country, total_spending DESC;


-- 4. Segment products by category and subcategory and calculate average price.
SELECT
    p.category,
    p.subcategory,
    ROUND(AVG(f.sales_amount / f.quantity), 2) AS average_price
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.category, p.subcategory
ORDER BY p.category, p.subcategory;