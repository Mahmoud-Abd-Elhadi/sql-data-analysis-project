/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

SELECT * FROM [gold].[fact_sales]
SELECT * FROM [gold].[dim_products]
SELECT * FROM [gold].[dim_customers]

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT TOP 5
    GDP.product_name ,
    SUM(sales_amount) AS Total_Revenue
FROM      [gold].[fact_sales] AS GFS 
LEFT JOIN [gold].[dim_products] AS GDP
ON GFS.product_key = GDP.product_key
GROUP BY GDP.product_name
ORDER BY SUM(sales_amount) DESC 

-- Complex but Flexibly Ranking Using Window Functions
SELECT
    *
FROM (
        SELECT
            GDP.product_name ,
            SUM(sales_amount) AS Total_Revenue ,
            RANK() OVER (ORDER BY SUM(sales_amount) DESC) AS RN
        FROM [gold].[fact_sales] AS GFS 
        LEFT JOIN [gold].[dim_products] AS GDP
        ON GFS.product_key = GDP.product_key
        GROUP BY GDP.product_name
      ) AS RANKING_TABLE
WHERE RN <= 5

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
    GDP.product_name ,
    SUM(sales_amount) AS Total_Revenue
FROM      [gold].[fact_sales] AS GFS 
LEFT JOIN [gold].[dim_products] AS GDP
ON GFS.product_key = GDP.product_key
GROUP BY GDP.product_name
ORDER BY SUM(sales_amount) ASC

SELECT
    *
FROM (
        SELECT
            GDP.product_name ,
            SUM(sales_amount) AS Total_Revenue ,
            RANK() OVER (ORDER BY SUM(sales_amount) ASC) AS RN
        FROM [gold].[fact_sales] AS GFS 
        LEFT JOIN [gold].[dim_products] AS GDP
        ON GFS.product_key = GDP.product_key
        GROUP BY GDP.product_name
      ) AS RANKING_TABLE
WHERE RN <= 5
-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
    GDC.customer_id ,
    GDC.first_name ,
    GDC.last_name ,
    SUM(sales_amount) AS Total_Revenue
FROM      [gold].[fact_sales] AS GFS
LEFT JOIN [gold].[dim_customers] AS GDC
ON GFS.customer_key = GDC.customer_key
GROUP BY GDC.customer_id ,
         GDC.first_name ,
         GDC.last_name
ORDER BY SUM(sales_amount) DESC

-- The 3 customers with the fewest orders placed
SELECT TOP 3
    GDC.customer_key ,
    GDC.first_name ,
    GDC.last_name ,
    COUNT(DISTINCT order_number) AS Total_Order
FROM      [gold].[fact_sales] AS GFS
LEFT JOIN [gold].[dim_customers] AS GDC
ON GFS.customer_key = GDC.customer_key
GROUP BY GDC.customer_key ,
         GDC.first_name ,
         GDC.last_name 
ORDER BY Total_Order
