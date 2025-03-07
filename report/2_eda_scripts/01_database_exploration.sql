/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- 1. Explore All Objects in the Database
SELECT 
	*
FROM 
	INFORMATION_SCHEMA.TABLES;

-- 2. Explore All Columns in the Database
SELECT 
	*
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_NAME= 'dim_customers';

