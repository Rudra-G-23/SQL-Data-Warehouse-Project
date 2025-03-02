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

-- ============================================================================
-- >> ERP Customer Table (erp_cust_az12)
-- ============================================================================

-- Check all columns and ensure transformations are working correctly
SELECT
    cid,
    CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
        ELSE cid
    END AS transformed_cid,
    bdate,
    gen
FROM 
    bronze.erp_cust_az12
WHERE
    CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
        ELSE cid
    END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info);

-- Check for invalid birth dates
SELECT
    bdate,
    gen
FROM 
    bronze.erp_cust_az12
WHERE
    bdate < '1924-02-01' OR bdate > TO_DATE('2025-03-02', 'YYYY-MM-DD');

-- Standardize gender values
SELECT DISTINCT
    gen,
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        ELSE 'Unknown'
    END AS standardized_gen
FROM 
    bronze.erp_cust_az12;

-- ============================================================================
-- >> ERP Location Table (erp_loc_a101)
-- ============================================================================

-- Check data standardization and consistency
SELECT
    cid,
    REPLACE(cid, '-', '') AS cleaned_cid,
    cntry
FROM
    bronze.erp_loc_a101
WHERE
    REPLACE(cid, '-', '') NOT IN (
        SELECT CST_KEY FROM silver.crm_cust_info
    );

-- Standardize country names
SELECT DISTINCT
    cntry,
    CASE
        WHEN UPPER(TRIM(cntry)) IN ('USA', 'US', 'UNITED STATUS') THEN 'United States'
        WHEN TRIM(cntry) IN ('DE') THEN 'Germany'
        WHEN TRIM(cntry) IS NULL OR TRIM(cntry) = '' THEN 'Unknown'
        ELSE cntry
    END AS standardized_cntry
FROM
    bronze.erp_loc_a101;

-- ============================================================================
-- >> ERP Product Category Table (erp_px_cat_g1v2)
-- ============================================================================

-- Check for unwanted spaces in columns
SELECT DISTINCT
    cat,
    subcat,
    maintenance
FROM
    bronze.erp_px_cat_g1v2
WHERE
    cat != TRIM(cat) 
    OR subcat != TRIM(subcat) 
    OR maintenance != TRIM(maintenance);

-- Retrieve distinct values for category-related fields
SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2;
SELECT DISTINCT subcat FROM bronze.erp_px_cat_g1v2;
SELECT DISTINCT maintenance FROM bronze.erp_px_cat_g1v2;


-- ============================================================================
-- END OF SCRIPT
-- ============================================================================
