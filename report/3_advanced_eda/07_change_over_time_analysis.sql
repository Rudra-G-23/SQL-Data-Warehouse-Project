/*
===============================================================================
Change Over Time Analysis 
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date/Time Functions: EXTRACT(), DATE_TRUNC(), TO_CHAR()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Analyze sales performance over time

-- Yearly Analysis
SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_year
ORDER BY order_year;

-- Monthly Analysis (using DATE_TRUNC)
SELECT
    DATE_TRUNC('month', order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_month
ORDER BY order_month;

-- Monthly Analysis (formatted output)
SELECT
    TO_CHAR(order_date, 'YYYY-Mon') AS order_month,  
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY order_month
ORDER BY order_month;


-- Change over time (Yearly)
SELECT
    EXTRACT(YEAR FROM order_date) AS years,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY years
ORDER BY years, total_sales; 

-- Change over time (Monthly)
SELECT
    EXTRACT(MONTH FROM order_date) AS months,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY months
ORDER BY months, total_sales; 

-- Change over time (Monthly with Year and Month Name, filtered by year)
SELECT
    EXTRACT(YEAR FROM order_date) AS years,
    EXTRACT(MONTH FROM order_date) AS months,
    TO_CHAR(order_date, 'YYYY-Mon') AS month_name,  -- Formatted month name
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
  AND EXTRACT(YEAR FROM order_date) = 2013  -- Example filter: Sales in 2013
GROUP BY years, months, month_name
ORDER BY years, months, total_sales;