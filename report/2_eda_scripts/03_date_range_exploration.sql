/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), EXTRACT(), AGE()
===============================================================================
*/

-- 1. Explore all countries our customers come from and determine the sales data range.
-- How many years of sales are available?
SELECT
    MIN(order_date) AS first_order_date,  -- Earliest order date
    MAX(order_date) AS last_order_date,   -- Latest order date
    EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) AS order_range_years, -- Calculate the difference in years between the first and last order dates
    AGE(MAX(order_date), MIN(order_date)) AS order_range -- Calculate the full time difference between the first and last order dates
FROM
    gold.fact_sales;

-- 2. Find the youngest and the oldest customer and their ages.
SELECT
    MIN(birth_date) AS oldest_birthdate,      -- Oldest customer's birthdate
    EXTRACT(YEAR FROM AGE(NOW(), MIN(birth_date))) AS oldest_age, -- Calculate the age of the oldest customer
    MAX(birth_date) AS youngest_birthdate,    -- Youngest customer's birthdate
    EXTRACT(YEAR FROM AGE(NOW(), MAX(birth_date))) AS youngest_age  -- Calculate the age of the youngest customer
FROM
    gold.dim_customers;