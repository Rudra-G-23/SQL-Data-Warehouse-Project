/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors.

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend
		
How to Used:
	- SELECT * FROM gold.report_customers;
===============================================================================
*/

DROP VIEW IF EXISTS gold.report_customers;

CREATE OR REPLACE VIEW gold.report_customers AS  -- Create the view

WITH customer_spending AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
    SELECT
        f.order_date,
        f.product_key,
        f.sales_amount,
        f.quantity,
        f.order_number,
        c.customer_number,
        c.customer_key,
        EXTRACT(YEAR FROM AGE(NOW(), c.birth_date)) AS age,  -- Calculate age
        CONCAT(c.first_name, ' ', c.last_name) AS full_name  -- Full name
    FROM 
        gold.fact_sales f
        LEFT JOIN gold.dim_customers c
            ON f.customer_key = c.customer_key
    WHERE
        order_date IS NOT NULL
), customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
    SELECT
        customer_number,
        customer_key,
        full_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,        -- Total distinct orders
        COUNT(DISTINCT product_key) AS total_products,      -- Total distinct products
        SUM(sales_amount) AS total_sales,                  -- Total sales amount
        MAX(order_date) AS last_order_date,                -- Date of last order
        -- Calculate lifespan in months
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan,
        SUM(quantity) AS total_quantity                    -- Total quantity purchased
    FROM 
        customer_spending  
    GROUP BY
        customer_number,
        customer_key,
        full_name,
        age
)
SELECT
    customer_number,
    customer_key,
    full_name,
    age,
    CASE 
        WHEN age < 20 THEN '<20'  -- Corrected age group label for consistency
        WHEN age BETWEEN 20 AND 29 THEN '20-29' 
        WHEN age BETWEEN 30 AND 39 THEN '30-39' 
        WHEN age BETWEEN 40 AND 49 THEN '40-49' 
        ELSE '50+'
    END AS age_group,  -- Added alias for clarity
    CASE
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    total_orders,
    total_products,
    total_quantity,
    total_sales,
    last_order_date,
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_order_date)) AS recency, -- Recency in months
    lifespan,
    -- Average Order Value (handle potential division by zero)
    COALESCE(total_sales / NULLIF(total_orders, 0), 0) AS avg_order_value,
    -- Average Monthly Spending (handle potential division by zero)
    ROUND(COALESCE(total_sales / NULLIF(lifespan, 0), 0), 2) AS avg_monthly_spending
FROM 
    customer_aggregation
ORDER BY 
    customer_number,
    customer_key,
    full_name,
    age; 