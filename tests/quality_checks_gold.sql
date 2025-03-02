/*
===============================================================================
Quality Checks for Gold Schema
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency, 
    and accuracy of the Gold Layer. These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships in the data model for analytical purposes.

Usage Notes:
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- -----------------------------------------------------------------------------
-- >> Dimension: dim_customer
-- -----------------------------------------------------------------------------

-- Check for duplicate customer IDs introduced by new join logic
SELECT 
    cst_id, 
    COUNT(*) 
FROM (
    SELECT
        ci.cst_id,
        ci.cst_key,
        ci.cst_firstname,
        ci.cst_lastname,
        ci.cst_marital_status,
        ci.cst_gndr,
        ci.cst_create_date,
        ca.bdate,
        ca.gen,
        la.cntry
    FROM 
        silver.crm_cust_info AS ci
    LEFT JOIN silver.erp_cust_az12 AS ca
        ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp_loc_a101 AS la
        ON ci.cst_key = la.cid
) AS subquery
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Check Gender column consistency
SELECT
    DISTINCT
    ci.cst_gndr AS crm_gender,
    ca.gen AS erp_gender,
    CASE 
        WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'Unknown')
    END AS resolved_gender -- CRM is the master for gender info
FROM 
    silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
    ON ci.cst_key = la.cid;

-- Validate gender consistency after view creation
SELECT DISTINCT gender FROM gold.dim_customers;

-- -----------------------------------------------------------------------------
-- >> Foreign Key Integrity Check (Fact & Dimension Tables)
-- -----------------------------------------------------------------------------
SELECT * 
FROM gold.fact_sales AS F
LEFT JOIN gold.dim_customers AS C ON C.CUSTOMER_KEY = F.CUSTOMER_KEY
LEFT JOIN gold.dim_products AS P ON P.PRODUCT_KEY = F.PRODUCT_KEY
WHERE C.CUSTOMER_KEY IS NULL;

-- ============================================================================
-- END OF SCRIPT
-- ============================================================================
