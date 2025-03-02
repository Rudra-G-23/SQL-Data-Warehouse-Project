/*
===================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===================================================================================

Script Purpose:
    This stored procedure peroforms the ETL(Extract, Transform, Load) process to 
    Populate the  'silver' schema tables from the 'bronze' schema.

    It performs the following actions:
    - Truncates the silver tables before loading data.
    - Insert the clean and transformed date from Bronze into Silver Tables.

Parameters:
    None,
    This stored procedure does not accept any parameters or return any values.

How to use:
    CALL silver.load_silver();

===================================================================================

*/



CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    rows_count        INTEGER;
	start_time        TIMESTAMP;
    end_time          TIMESTAMP;
    interval_diff     INTERVAL;
	hours             INTEGER;
    minutes           INTEGER;
    seconds           INTEGER;
    milliseconds      INTEGER;
	batch_start_time  TIMESTAMP;
	batch_end_time    TIMESTAMP;
BEGIN

	 RAISE NOTICE '==================================================';
	 RAISE NOTICE '=========== LOADING SILVER LAYER =================';
	 RAISE NOTICE '==================================================';
	 RAISE NOTICE '';
	 
     RAISE NOTICE 'Starting silver.load_silver procedure';
	 RAISE NOTICE '';

	 RAISE NOTICE '---------------------------------------------------';
	 RAISE NOTICE '------------- Loading CRM Tables ------------------';
	 RAISE NOTICE '---------------------------------------------------';
	 RAISE NOTICE '';

	--------------------------------------------------------------------------------------------------------
	RAISE NOTICE '----------';
	batch_start_time := NOW();
	start_time := NOW();
	
	-- Truncate the Table & then insert into silver layer
	RAISE NOTICE '>> Truncate Table and insert into silver.crm_cust_info';
	TRUNCATE TABLE silver.crm_cust_info;
	
	-- Insert Table from bronze layer to silver
	INSERT INTO silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
	)
	SELECT
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		    CASE 
	        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Singel'
	        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	        ELSE 'Unknow'
	    END cst_marital_status, -- Normlize the marital status values to reader format
		    CASE 
	        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	        ELSE 'Unknow'
	    END cst_gndr, -- Normlize the gender values to reader format
		cst_create_date
	FROM (
		SELECT 
		*,
		ROW_NUMBER() OVER (
			PARTITION BY cst_id 
			ORDER BY cst_create_date DESC 
		) AS flag_last
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL
		)
	WHERE flag_last = 1; -- Select the most recent record per customer

	-- Count Rows
	GET DIAGNOSTICS rows_count = ROW_COUNT;
    RAISE NOTICE 'crm_cust_info: % rows affected', rows_count;
	
	-- TIME
	end_time := NOW();
    interval_diff := end_time - start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
    minutes := EXTRACT(MINUTE FROM interval_diff);
    seconds := EXTRACT(SECOND FROM interval_diff)::INTEGER;
    milliseconds := EXTRACT(MILLISECONDS FROM interval_diff)::INTEGER % 1000;
	RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
	RAISE NOTICE '----------';
    RAISE NOTICE '';
	--------------------------------------------------------------------------------------------------------



	--------------------------------------------------------------------------------------------------------
	RAISE NOTICE '----------';
	batch_start_time := NOW();
	start_time := NOW();
	
	-- Truncate the Table & then insert into silver layer
	RAISE NOTICE '>> Truncate Table and insert into silver.crm_prd_info';
	TRUNCATE TABLE silver.crm_prd_info;
	
	-- Insert Table from bronze layer to silver
	INSERT INTO silver.crm_prd_info (
		prd_id,
		cat_id,
		sls_prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	SELECT 
		prd_id,
		REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
		SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS sls_prd_key,
		prd_nm,
		COALESCE(prd_cost, 0) AS prd_cost,
		CASE UPPER(TRIM(prd_line))
	        WHEN 'M' THEN 'Mountain'
	        WHEN 'R' THEN 'Road'
			WHEN 's' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
	        ELSE 'Unknow'
	    END AS prd_line, -- Normalization of prd_line
		prd_start_dt,
		LEAD(prd_start_dt) OVER ( PARTITION BY prd_key ORDER BY prd_start_dt) - 1 AS prd_end_dt
	FROM 
		bronze.crm_prd_info;

	-- Count Rows
	GET DIAGNOSTICS rows_count = ROW_COUNT;
    RAISE NOTICE 'crm_prd_info: % rows affected', rows_count;
	
	-- TIME
	end_time := NOW();
    interval_diff := end_time - start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
    minutes := EXTRACT(MINUTE FROM interval_diff);
    seconds := EXTRACT(SECOND FROM interval_diff)::INTEGER;
    milliseconds := EXTRACT(MILLISECONDS FROM interval_diff)::INTEGER % 1000;
	RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
	RAISE NOTICE '----------';
    RAISE NOTICE '';
	--------------------------------------------------------------------------------------------------------

	
	--------------------------------------------------------------------------------------------------------
	RAISE NOTICE '----------';
	batch_start_time := NOW();
	start_time := NOW();
	
	-- Truncate the Table & then insert into silver layer
	RAISE NOTICE '>> Truncate Table and insert into silver.crm_sales_details';
	TRUNCATE TABLE silver.crm_sales_details;
	
	-- Insert Table from bronze layer to silver
	INSERT INTO silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
		
	)
	SELECT
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
	    CASE 
	        WHEN sls_order_dt = 0 
	             OR LENGTH(CAST(sls_order_dt AS VARCHAR)) != 8 THEN NULL
	        ELSE TO_DATE(CAST(sls_order_dt AS VARCHAR), 'YYYYMMDD')
	    END AS sls_order_dt,
		CASE 
	        WHEN sls_ship_dt = 0 
	             OR LENGTH(CAST(sls_ship_dt AS VARCHAR)) != 8 THEN NULL
	        ELSE TO_DATE(CAST(sls_ship_dt AS VARCHAR), 'YYYYMMDD')
	    END AS sls_ship_dt,
		CASE 
	        WHEN sls_due_dt = 0 
	             OR LENGTH(CAST(sls_due_dt AS VARCHAR)) != 8 THEN NULL
	        ELSE TO_DATE(CAST(sls_due_dt AS VARCHAR), 'YYYYMMDD')
	    END AS sls_due_dt,
	    CASE
	        WHEN sls_sales IS NULL THEN ABS(sls_quantity) * ABS(COALESCE(sls_price,0)) 
	        WHEN sls_sales < 0 THEN ABS(sls_sales)
	        WHEN sls_sales = 0 THEN ABS(sls_quantity) * ABS(COALESCE(sls_price,0)) 
	        WHEN ABS(sls_quantity) * ABS(sls_price) != sls_sales THEN ABS(sls_quantity) * ABS(sls_price)
	        ELSE sls_sales
	    END AS sls_sales, -- Handle invaild data & recalculate if original value is missing or incorrect
		ABS(sls_quantity) AS sls_quantity,
		CASE 
			WHEN sls_price < 0 THEN ABS(sls_price)
			WHEN sls_price = 0 THEN NULLIF(sls_price, 0)
			WHEN sls_price IS NULL THEN sls_sales / ABS(sls_quantity)
			ELSE sls_price
		END AS sls_price -- Derive price if original value is invaild
	FROM 
		bronze.crm_sales_details
	WHERE
	    sls_order_dt <= sls_ship_dt 
	    AND sls_order_dt <= sls_due_dt
		AND sls_quantity != 0
		AND sls_price != 0;

	-- Count Rows
	GET DIAGNOSTICS rows_count = ROW_COUNT;
    RAISE NOTICE 'crm_sales_details: % rows affected', rows_count;
	
	-- TIME
	end_time := NOW();
    interval_diff := end_time - start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
    minutes := EXTRACT(MINUTE FROM interval_diff);
    seconds := EXTRACT(SECOND FROM interval_diff)::INTEGER;
    milliseconds := EXTRACT(MILLISECONDS FROM interval_diff)::INTEGER % 1000;
	RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
	RAISE NOTICE '----------';
    RAISE NOTICE '';
	--------------------------------------------------------------------------------------------------------

	
	
	 RAISE NOTICE '---------------------------------------------------';
	 RAISE NOTICE '------------- Loading ERP Tables ------------------';
	 RAISE NOTICE '---------------------------------------------------';
	 RAISE NOTICE '';

	--------------------------------------------------------------------------------------------------------
	RAISE NOTICE '----------';
	batch_start_time := NOW();
	start_time := NOW();
	
	-- Truncate the Table & then insert into silver layer
	RAISE NOTICE '>> Truncate Table and insert into silver.erp_cust_az12';
	TRUNCATE TABLE silver.erp_cust_az12;
	
	-- Insert Table from bronze layer to silver
	INSERT INTO silver.erp_cust_az12 (
		cid,
		bdate,
		gen
	)
	SELECT
	
		 CASE
		 	WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
			ELSE cid
		END AS cid,
		
		CASE 
			WHEN bdate > TO_DATE('2025-03-02', 'YYYY-MM-DD') THEN NULL
			ELSE bdate
		END AS bdate,
		
	    CASE 
	        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	        ELSE 'Unknown'
	    END AS gen
	FROM 
		bronze.erp_cust_az12;

	-- Count Rows
	GET DIAGNOSTICS rows_count = ROW_COUNT;
    RAISE NOTICE 'erp_cust_az12: % rows affected', rows_count;
	
	-- TIME
	end_time := NOW();
    interval_diff := end_time - start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
    minutes := EXTRACT(MINUTE FROM interval_diff);
    seconds := EXTRACT(SECOND FROM interval_diff)::INTEGER;
    milliseconds := EXTRACT(MILLISECONDS FROM interval_diff)::INTEGER % 1000;
	RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
	RAISE NOTICE '----------';
    RAISE NOTICE '';
	--------------------------------------------------------------------------------------------------------

	
	
	--------------------------------------------------------------------------------------------------------
	RAISE NOTICE '----------';
	batch_start_time := NOW();
	start_time := NOW();
	
	-- Truncate the Table & then insert into silver layer
	RAISE NOTICE '>> Truncate Table and insert into silver.erp_loc_a101';
	TRUNCATE TABLE silver.erp_loc_a101;
	
	-- Insert Table from bronze layer to silver
		INSERT INTO silver.erp_loc_a101 (
		cid,
		cntry
	)SELECT
		REPLACE(cid, '-', '') AS cid,
		CASE
			WHEN UPPER(TRIM(cntry)) IN ('USA', 'US', 'UNITED STATUS') THEN 'United States'
			WHEN TRIM(cntry) IN ('DE') THEN 'Germany'
			WHEN TRIM(cntry) IS NULL OR TRIM(cntry) = '' THEN 'Unkown'
			ELSE cntry
		END AS cntry
	FROM
		bronze.erp_loc_a101;

	-- Count Rows
	GET DIAGNOSTICS rows_count = ROW_COUNT;
    RAISE NOTICE 'erp_loc_a101: % rows affected', rows_count;
	
	-- TIME
	end_time := NOW();
    interval_diff := end_time - start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
    minutes := EXTRACT(MINUTE FROM interval_diff);
    seconds := EXTRACT(SECOND FROM interval_diff)::INTEGER;
    milliseconds := EXTRACT(MILLISECONDS FROM interval_diff)::INTEGER % 1000;
	RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
	RAISE NOTICE '----------';
    RAISE NOTICE '';
	--------------------------------------------------------------------------------------------------------


	 

	--------------------------------------------------------------------------------------------------------
	RAISE NOTICE '----------';
	batch_start_time := NOW();
	start_time := NOW();
	
	-- Truncate the Table & then insert into silver layer
	RAISE NOTICE '>> Truncate Table and insert into silver.erp_px_cat_g1v2';
	TRUNCATE TABLE silver.erp_px_cat_g1v2;
	
	-- Insert Table from bronze layer to silver
	INSERT INTO silver.erp_px_cat_g1v2 (
	    id,
	    cat,
	    subcat,
	    maintenance
	)
	SELECT
	    id,
	    cat,
	    subcat,
	    maintenance
	FROM
	    bronze.erp_px_cat_g1v2;

	-- Count Rows
	GET DIAGNOSTICS rows_count = ROW_COUNT;
    RAISE NOTICE 'erp_px_cat_g1v2: % rows affected', rows_count;
	
	-- TIME
	end_time := NOW();
    interval_diff := end_time - start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
    minutes := EXTRACT(MINUTE FROM interval_diff);
    seconds := EXTRACT(SECOND FROM interval_diff)::INTEGER;
    milliseconds := EXTRACT(MILLISECONDS FROM interval_diff)::INTEGER % 1000;
	RAISE NOTICE 'Load Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
	RAISE NOTICE '----------';
    RAISE NOTICE '';
	--------------------------------------------------------------------------------------------------------

	

	RAISE NOTICE '---------------------------------------------------';
	RAISE NOTICE 'silver.load_silver procedure completed';
	batch_end_time := NOW();
	interval_diff := batch_end_time - batch_start_time;
	hours := EXTRACT(HOUR FROM interval_diff);
    minutes := EXTRACT(MINUTE FROM interval_diff);
    seconds := EXTRACT(SECOND FROM interval_diff)::INTEGER;
    milliseconds := EXTRACT(MILLISECONDS FROM interval_diff)::INTEGER % 1000;
	RAISE NOTICE 'silver Layer Loading Duration: % hours, % minutes, % seconds, % milliseconds', hours, minutes, seconds, milliseconds;
    RAISE NOTICE '---------------------------------------------------';
	RAISE NOTICE '';
	

	-- Error Handling Logic
	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE '----------------------------------------------------';
	        RAISE NOTICE '--- ERROR OCCURRED DURING LOADING SILVER LAYER -----';
	        RAISE NOTICE 'Error Message: %', SQLERRM;
	        RAISE NOTICE 'Error Code: %', SQLSTATE;
	        RAISE NOTICE 'Error Detail: %', COALESCE(PG_EXCEPTION_DETAIL, 'N/A');
	        RAISE NOTICE 'Error Hint: %', COALESCE(PG_EXCEPTION_HINT, 'N/A');
	        RAISE NOTICE '----------------------------------------------------';
	        RAISE NOTICE '';

			-- Rollback the transaction
            ROLLBACK;
	
END;
$BODY$;
