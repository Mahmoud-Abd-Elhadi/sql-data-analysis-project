/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find the Total Sales
SELECT
    SUM(sales_amount) AS Total_Sales
FROM [gold].[fact_sales]

-- Find how many items are sold
SELECT
    SUM(quantity) AS Total_Quantity
FROM [gold].[fact_sales]

-- Find the average selling price
SELECT
    AVG(price) AS Avg_Price
FROM [gold].[fact_sales]

-- Find the Total number of Orders
SELECT
    COUNT(*) AS Total_Orders
FROM [gold].[fact_sales]

SELECT
    COUNT(Distinct order_number) AS Total_Unique_Orders
FROM [gold].[fact_sales]

-- Find the total number of products
SELECT
    COUNT(product_key) AS Total_Product
FROM [gold].[dim_products]

-- Find the total number of customers
SELECT
    COUNT(customer_id) total_customers
FROM [gold].[dim_customers]

-- Find the total number of customers that has placed an order
SELECT 
    COUNT(DISTINCT customer_key) AS total_customers
FROM [gold].[fact_sales]

-- Generate a Report that shows all key metrics of the business
SELECT 'Total_Sales' AS Measure_Name , SUM(sales_amount) AS Measure_Value FROM [gold].[fact_sales]
UNION ALL
SELECT 'Total_Quantity' ,  SUM(quantity) AS Total_Quantity FROM [gold].[fact_sales]
UNION ALL
SELECT 'Avg_Price'   , AVG(price) AS Avg_Price FROM [gold].[fact_sales]
UNION ALL
SELECT 'Total_Orders' , COUNT(*) AS Total_Orders FROM [gold].[fact_sales]
UNION ALL
SELECT 'Total_Unique_Orders' ,  COUNT(Distinct order_number) AS Total_Unique_Orders FROM [gold].[fact_sales]
UNION ALL
SELECT 'total_customers' , COUNT(customer_id) total_customers FROM [gold].[dim_customers]
 



