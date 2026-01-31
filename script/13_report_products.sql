/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================

IF OBJECT_ID ('gold.report_products') IS NOT NULL
    DROP VIEW gold.report_products
GO

CREATE VIEW gold.report_products AS 

/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/

WITH base_query AS 
(
    SELECT
    GDP.product_key ,
    GDP.product_name ,
    GDP.category ,
    GDP.subcategory ,
    GDP.cost ,
    GFS.customer_key ,
    GFS.order_number ,
    GFS.order_date ,
    GFS.sales_amount ,
    GFS.quantity 
    FROM      [gold].[fact_sales]   AS GFS
    LEFT JOIN [gold].[dim_products] AS GDP
    ON GFS.product_key = GDP.product_key
    WHERE GFS.order_date IS NOT NULL
)

, product_aggregations AS 

/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/

(
    SELECT
        product_key ,
        product_name ,
        category ,
        subcategory ,
        cost ,
        MIN(order_date)                                     AS first_sale_date ,
        MAX(order_date)                                     AS last_sale_date ,
        SUM(quantity)                                       AS total_quantity ,
        SUM(sales_amount)                                   AS total_sales ,
        COUNT(DISTINCT order_number)                        AS total_order ,
        COUNT(DISTINCT customer_key)                        AS total_customer ,
        DATEDIFF(MONTH , MIN(order_date) , MAX(order_date)) AS lifespan 
    FROM base_query
    GROUP BY 
         product_key,
        product_name,
        category,
        subcategory,
        cost 
)

/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/

SELECT
    product_key ,
    product_name ,
    category ,
    subcategory ,
    cost ,
    last_sale_date ,
    DATEDIFF(MONTH , last_sale_date , GETDATE()) AS recency_in_months ,
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales > 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END product_segment ,
    lifespan ,
    total_order ,
    total_sales ,
    total_quantity ,
    total_customer ,
    ROUND((total_sales / NULLIF(total_quantity , 0)) , 2) AS avg_selling_price ,

    -- Average Order Revenue (AOR)
    CASE
        WHEN total_order = 0 THEN 0 
        ELSE total_sales / total_order
    END avg_order_revenue ,

    -- Average Monthly Revenue
    CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END avg_monthly_revenue
FROM product_aggregations

SELECT * FROM [gold].[report_products]