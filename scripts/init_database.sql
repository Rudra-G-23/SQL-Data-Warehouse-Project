/*
================================================================
CREATE DATABASE & SCHEMAS
================================================================
Script Purpose:
    This script creates a new database named 'datawarehouse' after checking if it already exists.
    First, it terminates active connections if the database is active, then it is dropped and recreated.
    Additionally, the script sets up three schemas within the database: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'datawarehouse' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/

-- Terminate active connections to the 'datawarehouse' database
-- Avoid terminating the current connection
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'datawarehouse' AND pid <> pg_backend_pid(); 

-- Drop the database if it exists
DROP DATABASE IF EXISTS datawarehouse;

-- Recreate the database
CREATE DATABASE datawarehouse;

-- Connect to the newly created database
\c datawarehouse;

-- Create Schemas
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;