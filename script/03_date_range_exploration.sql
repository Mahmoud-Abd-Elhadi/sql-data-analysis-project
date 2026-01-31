/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

-- Determine the first and last order date and the total duration in months
SELECT
    MIN(order_date) AS FIRST_ORDER ,
    MAX(order_date) AS LAST_ORDER  ,
    DATEDIFF(MONTH , MIN(order_date) , MAX(order_date)) AS DIFF_MONTH
FROM [gold].[fact_sales]


SELECT
    MIN(order_date) AS FIRST_ORDER ,
    MAX(order_date) AS LAST_ORDER  ,
    DATEDIFF(DAY , MIN(order_date) , MAX(order_date)) / 30.0 AS DIFF_MONTH
FROM [gold].[fact_sales]


SELECT 
    MIN(order_date) AS FIRST_ORDER,
    MAX(order_date) AS LAST_ORDER,
    CAST(DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) / 12 AS VARCHAR) + ' Years & ' +
    CAST(DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) % 12 AS VARCHAR) + ' Months' AS READABLE_DURATION
FROM [gold].[fact_sales];


-- Find the youngest and oldest customer based on birthdate
SELECT 
    MIN(birthdate) AS Oldest_Birthdate ,
    MAX(birthdate) AS Youngest_Birthdate ,
    DATEDIFF(YEAR , MIN(birthdate) , GETDATE()) AS Oldest_Age ,
    DATEDIFF(YEAR , MAX(birthdate) , GETDATE()) AS Youngest_Age
FROM [gold].[dim_customers]




 
 