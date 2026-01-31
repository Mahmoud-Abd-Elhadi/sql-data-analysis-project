/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

SELECT * FROM [gold].[fact_sales]
SELECT * FROM [gold].[dim_products]
SELECT * FROM [gold].[dim_customers]

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */
--------------------
---==> Using CTEs 

WITH yearly_product_sales AS
(
    SELECT
            YEAR(GFS.order_date) AS Order_Year ,
            GDP.product_name ,
            SUM(GFS.sales_amount) AS Total_Sales
        FROM      [gold].[fact_sales]   AS GFS
        LEFT JOIN [gold].[dim_products] AS GDP
        ON GFS.product_key = GDP.product_key
        WHERE GFS.order_date IS NOT NULL
        GROUP BY YEAR(GFS.order_date) , GDP.product_name
)

SELECT 
    Order_Year ,
    product_name ,
    Total_Sales ,
    AVG(Total_Sales) OVER(PARTITION BY product_name) AS Avg_Sales ,
    Total_Sales - AVG(Total_Sales) OVER(PARTITION BY product_name) AS Diff_Avg ,
    CASE
        WHEN Total_Sales - AVG(Total_Sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN Total_Sales - AVG(Total_Sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END Avg_Change ,
    -- Year-over-Year Analysis
    LAG(Total_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) AS py_sales ,
    Total_Sales - LAG(Total_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) AS diff_py ,
    CASE
        WHEN Total_Sales - LAG(Total_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) > 0 THEN 'Increase'
        WHEN Total_Sales - LAG(Total_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END Py_Change
FROM yearly_product_sales

-----------------------------
---==> Using Nested Subquery

SELECT 
    Order_Year ,
    product_name ,
    Total_Sales ,
    Avg_Change ,
    Py_Change
FROM (
        SELECT 
            Order_Year ,
            product_name ,
            Total_Sales ,
            AVG(Total_Sales) OVER(PARTITION BY product_name) AS Avg_Sales ,
            Total_Sales - AVG(Total_Sales) OVER(PARTITION BY product_name) AS Diff_Avg ,
            CASE
                WHEN Total_Sales - AVG(Total_Sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Avg'
                WHEN Total_Sales - AVG(Total_Sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Avg'
                ELSE 'Avg'
            END Avg_Change ,
            -- Year-over-Year Analysis
            LAG(Total_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) AS py_sales ,
            Total_Sales - LAG(Total_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) AS diff_py ,
            CASE
                WHEN Total_Sales - LAG(Total_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) > 0 THEN 'Increase'
                WHEN Total_Sales - LAG(Total_Sales) OVER(PARTITION BY product_name ORDER BY Order_Year) < 0 THEN 'Decrease'
                ELSE 'No Change'
            END Py_Change
        FROM (
                SELECT
                    YEAR(GFS.order_date) AS Order_Year ,
                    GDP.product_name ,
                    SUM(GFS.sales_amount) AS Total_Sales
                FROM      [gold].[fact_sales]   AS GFS
                LEFT JOIN [gold].[dim_products] AS GDP
                ON GFS.product_key = GDP.product_key
                WHERE GFS.order_date IS NOT NULL
                GROUP BY YEAR(GFS.order_date) , GDP.product_name
              ) AS T
         ) AS N

-----------------------------------------------------------------------------------
 
 