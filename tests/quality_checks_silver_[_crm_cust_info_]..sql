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

/*
===============================================================================
>> crm_cust_info

- Check for Nulls & Duplicates in PK 
- Check Unwanted Spaces in columns
- Data Standardization & Consistency (cst_gndr)
- Data Standardization & Consistency (cst_marital_status)
- Check the Data Type
===============================================================================
*/

-------------------------------------------------
-- Check for Nulls & Duplicates in PK 
-- Expectation: No Result
-------------------------------------------------
SELECT
    cst_id,
    COUNT(*)
FROM
    bronze.crm_cust_info
GROUP BY
    cst_id
HAVING
    COUNT(*) > 1
    OR cst_id IS NULL;

-- Process to Resolve
-- Step 1: Focus on one number 
SELECT * 
FROM bronze.crm_cust_info
WHERE cst_id = 29466;

-- Step 2: Find the most recent cst_create_date from table
SELECT 
    *,
    ROW_NUMBER() OVER (
        PARTITION BY cst_id 
        ORDER BY cst_create_date DESC 
    ) AS flag_last
FROM bronze.crm_cust_info
WHERE cst_id = 29466;

-- Step 3: Show only flag_last = 1 values in table & remove others
SELECT 
    *
FROM (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY cst_id 
            ORDER BY cst_create_date DESC 
        ) AS flag_last
    FROM bronze.crm_cust_info
    WHERE cst_id IS NOT NULL
) AS subquery
WHERE flag_last = 1;

-------------------------------------------------
-- Check for Unwanted Spaces
-- Expectation: No Results
-------------------------------------------------
-- Step 1: Find values that are not equal to their trimmed version
SELECT 
    cst_firstname
FROM 
    bronze.crm_cust_info
WHERE
    cst_firstname != TRIM(cst_firstname);

-- Step 2: Check for other columns

-------------------------------------------------
-- Data Standardization & Consistency (cst_gndr)
-------------------------------------------------
SELECT DISTINCT(cst_gndr)
FROM bronze.crm_cust_info;

-- Step 1: Convert abbreviations to full names
SELECT 
    cst_gndr,
    CASE 
        WHEN cst_gndr = 'F' THEN 'Female'
        WHEN cst_gndr = 'M' THEN 'Male'
        ELSE 'Unknown'
    END AS standardized_gndr
FROM 
    bronze.crm_cust_info;

-- Step 2: Handle lower-case values
SELECT 
    cst_gndr,
    CASE 
        WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
        WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
        ELSE 'Unknown'
    END AS standardized_gndr
FROM 
    bronze.crm_cust_info;

-- Step 3: Remove unwanted spaces
SELECT 
    cst_gndr,
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'Unknown'
    END AS standardized_gndr
FROM 
    bronze.crm_cust_info;

-------------------------------------------------
-- Data Standardization & Consistency (cst_marital_status)
-------------------------------------------------
SELECT 
    cst_marital_status,
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'Unknown'
    END AS standardized_marital_status
FROM 
    bronze.crm_cust_info;

-------------------------------------------------
-- Check the Data Type for bronze.crm_cust_info
-------------------------------------------------
SELECT 
    column_name, 
    data_type
FROM 
    information_schema.columns
WHERE 
    table_name = 'crm_cust_info' 
    AND table_schema = 'bronze';
-------------------------------------------------

-- ============================================================================
-- END OF SCRIPT
-- ============================================================================
