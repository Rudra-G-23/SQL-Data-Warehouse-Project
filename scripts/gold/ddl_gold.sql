/*
===============================================================================
DDL Script: Create Gold Views (PostgreSQL)
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- >> Create Dimension: gold.dim_customers
-- =============================================================================
DROP VIEW IF EXISTS gold.dim_customers;

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_marital_status AS marital_status,
    CASE
        WHEN ci.cst_gndr != 'Unknow' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'Unknown') 
    END AS gender,
    ca.bdate AS birth_date,
    ci.cst_create_date AS create_date
FROM
    silver.crm_cust_info AS ci
    LEFT JOIN silver.erp_cust_az12 AS ca ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 AS la ON ci.cst_key = la.cid;


-- =============================================================================
-- >> Create Dimension: gold.dim_products
-- =============================================================================
DROP VIEW IF EXISTS gold.dim_products;

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY prd_start_dt, pn.sls_prd_key) AS product_key,
    pn.prd_id AS product_id,
    pn.sls_prd_key AS product_number,
    pn.prd_nm AS product_name,  
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance AS maintenance,
    pn.prd_cost AS product_cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_dt
FROM
    silver.crm_prd_info AS pn
    LEFT JOIN silver.erp_px_cat_g1v2 AS pc ON pn.cat_id = pc.id
WHERE
    pn.prd_end_dt IS NULL; -- Filter out historical products


-- =============================================================================
-- >> Create Fact Table: gold.fact_sales
-- =============================================================================
DROP VIEW IF EXISTS gold.fact_sales;

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_cust_id AS customer_id,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity, 
    sd.sls_price AS price
FROM
    silver.crm_sales_details AS sd
    LEFT JOIN gold.dim_products AS pr ON pr.product_number = sd.sls_prd_key
    LEFT JOIN gold.dim_customers AS cu ON cu.customer_id = sd.sls_cust_id;
