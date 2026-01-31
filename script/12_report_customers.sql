/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
WITH base_query AS
(
	SELECT
		GFS.order_number,
		GFS.product_key,
		GFS.order_date,
		GFS.sales_amount,
		GFS.quantity,
		GDC.customer_key,
		GDC.customer_number,
		CONCAT(GDC.first_name , ' ' , GDC.last_name) AS Full_Name ,
		DATEDIFF(YEAR , GDC.birthdate , GETDATE()) AS Age
	FROM	  [gold].[fact_sales]    AS GFS
	LEFT JOIN [gold].[dim_customers] AS GDC
	ON GFS.customer_key = GDC.customer_key
	WHERE GFS.order_date IS NOT NULL
) 

, customer_aggregation AS 
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
(
	SELECT
		customer_key ,
		customer_number ,
		Full_Name ,
		Age ,
		MIN(order_date)										AS First_Order_Date ,
		MAX(order_date)										AS Last_Order_Date ,
		COUNT(DISTINCT order_number)						AS Total_Orders ,
		SUM(sales_amount)								    AS Total_Sales ,
		SUM(quantity)										AS Total_Quantity ,
		COUNT(product_key)								    AS Total_Product ,
		DATEDIFF(MONTH , MIN(order_date) , MAX(order_date)) AS Lifespan
	FROM base_query
	GROUP BY
		customer_key ,
		customer_number ,
		Full_Name ,
		Age
)

SELECT
	customer_key ,
	customer_number ,
	Full_Name ,
	Age ,
	CASE
		WHEN age < 20 THEN 'Under 20'
		WHEN age between 20 and 29 THEN '20-29'
		WHEN age between 30 and 39 THEN '30-39'
		WHEN age between 40 and 49 THEN '40-49'
		ELSE '50 and above'
	END Age_Group ,
	CASE
		WHEN lifespan >= 12 AND Total_Sales > 5000  THEN 'VIP'
		WHEN lifespan >= 12 AND Total_Sales <= 5000 THEN 'Regular'
		ELSE 'NEW'
	END Customer_Segment ,
	Last_Order_Date ,
	DATEDIFF(MONTH , Last_Order_Date ,GETDATE()) AS Recency ,
	Total_Orders ,
	Total_Sales ,
	Total_Quantity ,
	Lifespan ,

	-- Compuate average order value (AVO)
	CASE
		WHEN Total_Sales = 0 THEN 0
		ELSE Total_Sales / Total_Orders
	END Avg_Order_Value ,

	-- Compuate average monthly spend
	CASE
		WHEN Lifespan = 0 THEN Total_Sales
		ELSE Total_Sales / Lifespan 
	END Avg_Monthly_Spend
FROM customer_aggregation

SELECT * FROM gold.report_customers  
ORDER BY customer_key , customer_number



