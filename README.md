# 📊 Advanced SQL Sales Data Analysis Project

## 📝 Project Overview
This project simulates a comprehensive data analysis workflow for a retail company using **SQL**. The goal is to transform raw sales data into actionable business insights that support decision-making.

The project covers the entire data lifecycle: from database creation and data cleaning to exploratory data analysis (EDA) and advanced reporting.

---

## 📂 Repository Structure
The project is organized into two main folders for clarity:

### 1. 📁 `dataset/`
Contains the raw data files in CSV format (Star Schema Design):
- **`dim_customers.csv`**: Customer demographic details.
- **`dim_products.csv`**: Product information and categories.
- **`fact_sales.csv`**: Historical sales transactions table.

### 2. 📁 `script/`
Contains numbered SQL scripts to be executed sequentially:

| Script No. | Description & Objective |
|:---:|:---|
| **00** | **`init_database.sql`**: Database DDL, table creation, and data import setup. |
| **01-04** | **Exploration Scripts**: Exploring database dimensions, date ranges, and calculating core measures. |
| **05-08** | **Deep Dive Analysis**: Advanced analysis including Magnitude, Ranking, Change Over Time, and Cumulative calculations. |
| **09** | **`performance_analysis.sql`**: Evaluating product and order performance metrics. |
| **10** | **`data_segmentation.sql`**: Segmenting customers and products to identify patterns (e.g., RFM). |
| **11** | **`part_to_whole_analysis.sql`**: Analyzing the contribution of specific categories to total sales. |
| **12-13** | **Reporting**: Generating final, presentation-ready reports (Customer & Product Reports). |

---

## 🛠️ Tech Stack & Skills Demonstrated
- **SQL Server (T-SQL)**: Primary language used for analysis.
- **Advanced Analytical Techniques**:
  - **Window Functions**: (`OVER`, `RANK`, `DENSE_RANK`, `LEAD`, `LAG`) for trend analysis and ranking.
  - **CTEs (Common Table Expressions)**: For writing modular and readable code.
  - **Aggregations**: (`SUM`, `AVG`, `COUNT`, `GROUP BY`) for KPIs.
  - **Data Cleaning**: Handling NULLs and formatting data types using `ISNULL`, `COALESCE`, and `CAST`.

---

## 🔍 Key Insights & Business Questions
This project answers critical business questions, such as:
1. **Customer Behavior:** Who are the VIP customers? What is the retention rate?
2. **Product Performance:** Which products drive the most revenue? Which are underperforming?
3. **Sales Trends:** How are sales performing Month-over-Month (MoM) and Year-over-Year (YoY)?
4. **Cumulative Growth:** What is the total running total of sales over time?

---

## 🚀 How to Run This Project
1. Clone the repository.
2. Execute `00_init_database.sql` to set up the database structure.
3. Import the CSV files from the `dataset/` folder into the respective tables.
4. Run the analytical scripts in order (from `01` to `13`) to generate insights.

---

## 👤 Author
**Mahmoud Abd Elhadi** *Data Analyst & SQL Developer*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-%230077B5.svg?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mahmoud-abd-elhadi/)
[![GitHub](https://img.shields.io/badge/GitHub-%23121011.svg?logo=github&logoColor=white)](https://github.com/Mahmoud-Abd-Elhadi) 
 
---
*This project was built to demonstrate advanced SQL capabilities in Data Analysis and Engineering.*
