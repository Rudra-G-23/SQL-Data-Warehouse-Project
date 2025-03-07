/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG(), DISTINCT()
===============================================================================
*/

-- 1. Find the Total Sales
SELECT 
    SUM(sales_amount) AS total_sales_amount  
FROM 
    gold.fact_sales;


-- 2. Find how many items are sold
SELECT 
    SUM(quantity) AS total_quantity  
FROM 
    gold.fact_sales;


-- 3. Find the average selling price
SELECT 
    AVG(price) AS avg_price 
FROM 
    gold.fact_sales;


-- 4. Find the Total number of Orders
SELECT 
    COUNT(DISTINCT order_number) AS total_orders 
FROM
    gold.fact_sales;

-- 5. Find the total number of products
SELECT 
    COUNT(DISTINCT product_key) AS total_products 
FROM
    gold.fact_sales;

-- 6. Find the total number of customers that have placed an order 
SELECT 
    COUNT(DISTINCT customer_key) AS total_customers_with_orders
FROM
    gold.fact_sales;


-- 7. Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_values FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales 
UNION ALL
SELECT 'Avg Price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Products', COUNT(DISTINCT product_key) FROM gold.fact_sales
UNION ALL
SELECT 'Total Nr. Customers with Orders', COUNT(DISTINCT customer_key) FROM gold.fact_sales; 