/*
===============================================================================
                          Quality Checks for CRM Source
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- -----------------------------------------------------------------------------
-- >> Unwanted Spaces
-- -----------------------------------------------------------------------------
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM 
    bronze.crm_sales_details
WHERE 
    sls_ord_num != TRIM(sls_ord_num);

-- -----------------------------------------------------------------------------
-- >> Integrate Check for sls_prd_key & sls_cust_id
-- -----------------------------------------------------------------------------
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
FROM 
    bronze.crm_sales_details
WHERE 
    sls_prd_key NOT IN (SELECT sls_prd_key FROM bronze.crm_prd_info);

-- -----------------------------------------------------------------------------
-- >> Check all three date columns
-- -----------------------------------------------------------------------------
-- Step 1: Check for invalid Dates
SELECT
    NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM 
    bronze.crm_sales_details
WHERE
    sls_order_dt <= 0;

-- Step 2: Ensure Dates are 8 characters long
SELECT
    NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM 
    bronze.crm_sales_details
WHERE
    sls_order_dt <= 0 OR LENGTH(CAST(sls_order_dt AS VARCHAR)) != 8;

-- Step 3: Check for Dates within valid boundaries 
SELECT
    NULLIF(sls_ship_dt, 0) AS sls_ship_dt
FROM 
    bronze.crm_sales_details
WHERE
    sls_order_dt <= 0 
    OR LENGTH(CAST(sls_order_dt AS VARCHAR)) != 8
    OR LENGTH(CAST(sls_ship_dt AS VARCHAR)) > 20500101 
    OR LENGTH(CAST(sls_ship_dt AS VARCHAR)) < 19000101;

-- Step 4: Check Date Sequence Validity
SELECT 
    *
FROM 
    bronze.crm_sales_details
WHERE
    sls_order_dt > sls_ship_dt 
    OR sls_order_dt > sls_due_dt;

-- -----------------------------------------------------------------------------
-- >> Check the Sales & Quantity & Price Columns
-- -----------------------------------------------------------------------------
-- Ensure Sales = Quantity * Price and check for invalid values
SELECT
    DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM 
    bronze.crm_sales_details
WHERE
    sls_sales != sls_quantity * sls_price
    OR sls_sales IS NULL
    OR sls_quantity IS NULL
    OR sls_price IS NULL
    OR sls_sales <= 0
    OR sls_quantity <= 0
    OR sls_price <= 0
ORDER BY 
    sls_sales,
    sls_quantity,
    sls_price;

-- >> Apply corrections where needed
SELECT
    DISTINCT
    sls_sales AS OLD_SALES,
    sls_quantity,
    sls_price AS OLD_PRICE,

    CASE 
        WHEN sls_price < 0 THEN ABS(sls_price)
        WHEN sls_price = 0 THEN NULLIF(sls_price, 0)
        WHEN sls_price IS NULL THEN sls_sales / ABS(sls_quantity)
        ELSE sls_price
    END AS sls_price,
    
    CASE
        WHEN sls_sales IS NULL THEN ABS(sls_quantity) * ABS(COALESCE(sls_price,0))
        WHEN sls_sales < 0 THEN ABS(sls_sales)
        WHEN sls_sales = 0 THEN ABS(sls_quantity) * ABS(COALESCE(sls_price,0))
        WHEN ABS(sls_quantity) * ABS(sls_price) != sls_sales THEN ABS(sls_quantity) * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales

FROM 
    bronze.crm_sales_details
WHERE
    sls_sales != sls_quantity * sls_price
    OR sls_sales IS NULL
    OR sls_quantity IS NULL
    OR sls_price IS NULL
    OR sls_sales <= 0
    OR sls_quantity <= 0
    OR sls_price <= 0
    OR sls_price > sls_sales
    OR sls_quantity > sls_sales
ORDER BY 
    sls_sales,
    sls_quantity,
    sls_price;

-- ============================================================================
-- END OF SCRIPT
-- ============================================================================
