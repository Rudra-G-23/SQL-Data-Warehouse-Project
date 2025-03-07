/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
        - total orders
        - total sales
        - total quantity sold
        - total customers (unique)
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last sale)
        - average order revenue (AOR)
        - average monthly revenue
How to used:
	- SELECT * FROM gold.product_report; 
===============================================================================
*/

DROP VIEW IF EXISTS gold.product_report;  

CREATE OR REPLACE VIEW gold.product_report AS  -- Added schema and CREATE OR REPLACE

WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
    SELECT 
        f.order_number,
        f.order_date,
        f.customer_key,
        f.sales_amount,
        f.quantity,
        p.product_key,
        p.product_name,  
        p.category,
        p.subcategory,
        p.product_cost
    FROM
        gold.fact_sales f
        LEFT JOIN gold.dim_products p
            ON p.product_key = f.product_key
    WHERE
        order_date IS NOT NULL
), 
product_aggregations AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
    SELECT
        product_key,
        product_name,  
        category,
        subcategory,
        product_cost,
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS lifespan,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,  
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        MAX(order_date) AS last_order_date,
        -- Average selling price (handle potential division by zero)
        COALESCE(SUM(sales_amount) / NULLIF(SUM(quantity), 0), 0) AS avg_selling_price 
    FROM 
        base_query
    GROUP BY
        product_key,
        product_name,  
        category,
        subcategory,
        product_cost
)
/*---------------------------------------------------------------------------
 3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
    product_key,
    product_name,  
    category,
    subcategory,
    product_cost,
    last_order_date,
    EXTRACT(MONTH FROM AGE(CURRENT_DATE, last_order_date)) AS recency,
    CASE 
        WHEN total_sales > 50000 THEN 'High'
        WHEN total_sales BETWEEN 10000 AND 50000 THEN 'Mid'  
        ELSE 'Low'
    END AS product_performer,
    lifespan,
    total_orders,
    total_customers,  
    total_sales,
    total_quantity,
    avg_selling_price,
    -- Average Monthly Revenue (handle potential division by zero)
    ROUND(COALESCE(total_sales / NULLIF(lifespan, 0), 0), 2) AS avg_monthly_revenue,
    -- Average Order Revenue (handle potential division by zero)
    COALESCE(total_sales / NULLIF(total_orders, 0), 0) AS avg_order_revenue
FROM
    product_aggregations
ORDER BY 
    product_key;  