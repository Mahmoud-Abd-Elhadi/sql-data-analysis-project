/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

SELECT * FROM [gold].[fact_sales]

-- Calculate the total sales per month 
-- and the running total of sales over time 
SELECT
    Order_Date ,
    Total_Sales ,
    SUM(Total_Sales) OVER(ORDER BY Order_Date) AS running_total_sales ,
    AVG(Avg_Price)   OVER(ORDER BY Order_Date) AS moving_average_price
FROM (
        SELECT
             DATETRUNC(YEAR , order_date)   AS Order_Date ,
             SUM(sales_amount)              AS Total_Sales ,
             AVG(price)                     AS Avg_Price
        FROM [gold].[fact_sales] 
        WHERE order_date IS NOT NULL
        GROUP BY DATETRUNC(YEAR , order_date)
         ) AS T
