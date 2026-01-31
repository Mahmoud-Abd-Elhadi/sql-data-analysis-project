/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/
-- Which categories contribute the most to overall sales?

WITH category_sales AS 
(
    SELECT
        GDP.category ,
        SUM(GFS.sales_amount) AS Total_Sales
    FROM      [gold].[fact_sales]   AS GFS
    LEFT JOIN [gold].[dim_products] AS GDP
    ON GFS.product_key = GDP.product_key
    GROUP BY GDP.category
)

SELECT
    Category ,
    Total_Sales ,
    SUM(Total_Sales) OVER() Overall_Sales ,
    CONCAT(ROUND((CAST(Total_Sales AS FLOAT) / SUM(Total_Sales) OVER()) * 100 , 2) , '%') AS Percentage_Of_Total
FROM category_sales
ORDER BY Percentage_Of_Total DESC
