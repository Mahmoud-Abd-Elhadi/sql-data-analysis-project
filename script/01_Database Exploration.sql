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

USE [Datawarehouse]

-- Retrieve a list of all tables in the database
SELECT 
    TABLE_CATALOG ,
    TABLE_SCHEMA ,
    TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES

-- Retrieve all columns for a specific table (dim_customers)
SELECT
    TABLE_CATALOG ,
    TABLE_SCHEMA ,
    TABLE_NAME ,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'

-- Retrieve all columns for a specific table (dim_product)
SELECT
    TABLE_CATALOG ,
    TABLE_SCHEMA ,
    TABLE_NAME ,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_product'

-- Retrieve all columns for a specific table (fact_sales)
SELECT
    TABLE_CATALOG ,
    TABLE_SCHEMA ,
    TABLE_NAME ,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales'