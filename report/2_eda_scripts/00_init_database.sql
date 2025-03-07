/*
======================================================================================================
Create Database and Schemas (PostgreSQL Version)
======================================================================================================
Script Purpose:
    This script creates a new database named 'DataWarehouseAnalytics' if it doesn't already exist.
    It then creates three schemas within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script might require you to manually drop the database if it exists due to PostgreSQL's 
    handling of concurrent connections.  It's best practice to connect to a different database (e.g., 'postgres')
    to drop 'DataWarehouseAnalytics' if it exists.
    
How to used:
    - SELECT COUNT(*) FROM gold.dim_customers;
    - SELECT COUNT(*) FROM gold.dim_products;
    - SELECT COUNT(*) FROM gold.fact_sales;
======================================================================================================
*/


-- Connect to the 'postgres' database (or another database other than the one you are creating)
-- This is essential for dropping the target database if it exists.
-- psql command to connect to postgres
\c postgres  

-- Check if the database exists and drop it if it does.
-- Note:  You might need to disconnect other users connected to DataWarehouseAnalytics before dropping.
-- Use double quotes for case-sensitive names
DROP DATABASE IF EXISTS "DataWarehouseAnalytics"; 


-- Create the 'DataWarehouseAnalytics' database
-- Use double quotes for case-sensitive names
CREATE DATABASE "DataWarehouseAnalytics";  

-- Connect to the newly created 'DataWarehouseAnalytics' database
-- psql command to connect to DataWarehouseAnalytics
\c "DataWarehouseAnalytics" 

-- Create the schemas
CREATE SCHEMA IF NOT EXISTS gold;


-- Create the tables in the gold schema

CREATE TABLE gold.dim_customers (
    customer_key           PRIMARY KEY,  
    customer_id            INT,
    customer_number        VARCHAR(255),  
    first_name             VARCHAR(255),
    last_name              VARCHAR(255),
    country                VARCHAR(255),
    marital_status         VARCHAR(255),
    gender                 VARCHAR(255),
    birth_date             DATE,
    create_date            TIMESTAMP WITH TIME ZONE 
);

CREATE TABLE gold.dim_products (
    product_key           PRIMARY KEY,  
    product_id            INT,
    product_number        VARCHAR(255),
    product_name          VARCHAR(255),
    category_id           INT,
    category              VARCHAR(255),
    subcategory           VARCHAR(255),
    maintenance           INT, 
    product_cost          NUMERIC,  
    product_line          VARCHAR(255),
    start_dt              DATE
);

CREATE TABLE gold.fact_sales (
    order_number        VARCHAR(255), -- Order numbers can be strings
    product_key         INT REFERENCES gold.dim_products(product_key),  -- Foreign key constraint
    customer_key        INT REFERENCES gold.dim_customers(customer_key),  -- Foreign key constraint
    customer_id         INT,
    order_date          DATE,
    shipping_date       DATE,
    due_date            DATE,
    sales_amount        NUMERIC,  -- Use NUMERIC for monetary values
    quantity            INT,
    price               NUMERIC  -- Use NUMERIC for monetary values
);



-- Load data from CSV files

-- IMPORTANT: Adjust the file paths to your actual file locations.
-- It's best practice to use absolute paths to avoid any ambiguity.
-- Also, make sure the PostgreSQL user has read access to these files.


----------------------------------------------------------------------------------------------------
-->> gold.dim_customers
TRUNCATE TABLE gold.dim_customers;
TRUNCATE TABLE gold.dim_customers;
COPY gold.dim_customers
FROM "C:\Users\Rudra\Desktop\SQL Data Warehouse Project\report\1_gold_layer_datasets\dim_customers.csv"
DELIMITER ','
CSV HEADER;

-->> gold.dim_products
TRUNCATE TABLE gold.dim_products;
COPY gold.dim_products
FROM "C:\Users\Rudra\Desktop\SQL Data Warehouse Project\report\1_gold_layer_datasets\dim_products.csv"
DELIMITER ','
CSV HEADER;

-->> gold.fact_sales
TRUNCATE TABLE gold.fact_sales;
COPY gold.fact_sales
FROM "C:\Users\Rudra\Desktop\SQL Data Warehouse Project\report\1_gold_layer_datasets\fact_sales.csv"
DELIMITER ','
CSV HEADER;
----------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------
-- Use \copy for efficient data loading in psql.
-->> gold.dim_customers
\copy gold.dim_customers(customer_id, customer_number, first_name, last_name, country, marital_status, gender, birth_date, create_date)
 FROM 'C:/Users/Rudra/Desktop/SQL Data Warehouse Project/report/1_gold_layer_datasets/dim_customers.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',');

-->> gold.dim_products
\copy gold.dim_products(product_id, product_number, product_name, category_id, category, subcategory, maintenance, product_cost, product_line, start_dt) 
FROM 'C:/Users/Rudra/Desktop/SQL Data Warehouse Project/report/1_gold_layer_datasets/dim_products.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',');

-->> gold.fact_sales
\copy gold.fact_sales(order_number, product_key, customer_key, customer_id, order_date, shipping_date, due_date, sales_amount, quantity, price) 
FROM 'C:/Users/Rudra/Desktop/SQL Data Warehouse Project/report/1_gold_layer_datasets/fact_sales.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',');
----------------------------------------------------------------------------------------------------

-- Verify data load
SELECT COUNT(*) FROM gold.dim_customers;
SELECT COUNT(*) FROM gold.dim_products;
SELECT COUNT(*) FROM gold.fact_sales;

-- ============================================================================
-- END OF SCRIPT
-- ============================================================================