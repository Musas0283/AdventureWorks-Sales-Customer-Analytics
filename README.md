# AdventureWorks Sales Performance & Customer Analytics

## Project Overview

This project analyzes sales performance, customer purchasing behavior, product profitability, and customer retention using the **AdventureWorks2022** database.

The analysis combines **SQL Server (T-SQL)** for data exploration and business analysis with **Power BI** for interactive reporting and visualization.

The objective is to transform transactional sales data into actionable business insights that support sales strategy, customer retention, and product performance decisions.

## Tools and Technologies

- **SQL Server / SSMS:** Data exploration, joins, aggregations, CTEs, and window functions.
- **Power BI Desktop:** Data modeling, DAX measures, interactive dashboards, and reporting.
- **T-SQL:** Customer segmentation, revenue analysis, ranking, and growth calculations.
- **GitHub:** Project documentation and portfolio presentation.

## Dataset

**Source:** Microsoft AdventureWorks2022 sample database.

Key tables used:

- `Sales.SalesOrderHeader`
- `Sales.SalesOrderDetail`
- `Sales.Customer`
- `Sales.SalesTerritory`
- `Production.Product`
- `Production.ProductCategory`
- `Production.ProductSubcategory`

**Dataset coverage:** May 2011 – June 2014.

## Key Performance Indicators

| KPI | Result |
|---|---:|
| Total Merchandise Revenue | $109.85 million |
| Total Sales Orders | 31,465 |
| Purchasing Customers | 19,119 |
| Average Order Value | $3,491.02 |
| Sales Territories | 10 |

Revenue is calculated using `SalesOrderHeader.SubTotal`, excluding tax and freight.

## SQL Analysis

The project contains **32 documented SQL analyses** organized into five scripts.

### 01 — Database Exploration (Challenges 1–8)

Explored the database structure and established baseline metrics, including sales orders, order line items, purchasing customers, product counts, and sales territories.

### 02 — Sales Analysis (Challenges 9–13)

Analyzed monthly and annual revenue, sales order trends, territory performance, and top-selling products.

### 03 — Product Performance Analysis (Challenges 14–19)

Evaluated product sales volumes, category and subcategory revenue, estimated product profits, and gross profit margins.

Profitability calculations use standard product costs and should be interpreted as estimates rather than historical actual profit.

### 04 — Customer Analysis (Challenges 20–29)

Analyzed customer purchase frequency, top revenue-generating customers, customer segmentation, revenue contribution, and new versus returning customers.

Customer segments were defined as:

- **High Value:** $100,000 or more in lifetime merchandise revenue.
- **Medium Value:** $10,000 to under $100,000.
- **Low Value:** Under $10,000.

### 05 — Advanced SQL Analysis (Challenges 30–32)

Applied advanced SQL techniques to evaluate:

- Year-over-year customer retention using CTEs and self-joins.
- Customer lifetime revenue and ranking using `DENSE_RANK()`.
- Month-over-month revenue growth using `LAG()` and `NULLIF()`.

## Power BI Dashboard

The project includes a four-page interactive Power BI report.

### Page 1 — Sales Overview

Presents overall merchandise revenue, sales orders, purchasing customers, average order value, and sales trends.

### Page 2 — Product & Territory Performance

Analyzes product categories, top-selling products, and geographic sales contributions.

### Page 3 — Customer Analysis

Explores customer purchasing behavior and customer-related performance metrics.

### Page 4 — Customer Revenue Insights

Highlights customer lifetime revenue, revenue rankings, segmentation, and customer value.

The repository also includes a PDF export of the report for convenient viewing without Power BI Desktop.

## Key Business Insights

**Sales Performance**

AdventureWorks generated approximately **$109.85 million** in merchandise revenue across 31,465 sales orders.

**Product Performance**

The Bikes category contributed approximately **$94.65 million**, making it the largest product category by revenue.

**Territory Performance**

The Southwest sales territory generated approximately **$24.18 million** in merchandise revenue.

**Customer Value**

Customer 29818 generated approximately **$877,107** in lifetime merchandise revenue, demonstrating the importance of identifying high-value customers.

**Customer Retention**

Year-over-year customer retention varied across the observed purchasing cohorts:

| Customer Cohort | Next-Year Retention |
|---|---:|
| 2011 → 2012 | 14.30% |
| 2012 → 2013 | 56.96% |
| 2013 → 2014 | 25.08% |

The 2014 dataset covers only part of the year, which should be considered when interpreting the final retention figure.

## Business Recommendations

1. **Strengthen customer retention:** Investigate changes in repeat purchasing behavior and develop strategies to encourage returning customers.
2. **Prioritize high-value customers:** Use customer segmentation to support targeted loyalty and relationship management initiatives.
3. **Optimize product strategy:** Evaluate both revenue and estimated profit margins when prioritizing products.
4. **Improve territory performance:** Compare stronger and weaker territories to identify opportunities for sales improvement.
5. **Monitor monthly revenue growth:** Track changes in sales performance to support timely business decisions.

## Repository Structure

```text
AdventureWorks-Sales-Customer-Analytics/
│
├── SQL/
│   ├── 01_Database_Exploration.sql
│   ├── 02_Sales_Analysis.sql
│   ├── 03_Product_Performance_Analysis.sql
│   ├── 04_Customer_Analysis.sql
│   └── 05_Advanced_SQL_Analysis.sql
│
├── PowerBI/
│   ├── AdventureWorks_Sales_Analytics.pbix
│   └── AdventureWorks_Report.pdf
│
└── README.md
```

## How to Explore This Project

1. Review the SQL scripts in the `SQL` folder to understand the business questions and analytical methods.
2. Open the `.pbix` file in Power BI Desktop to explore the interactive report.
3. View the PDF export for a quick overview of the dashboard.
4. To reproduce the SQL analysis, restore the AdventureWorks2022 sample database in SQL Server and execute the scripts in SSMS.

## Skills Demonstrated

- SQL joins and multi-table relationships
- Data aggregation and grouping
- Common Table Expressions (CTEs)
- Window functions: `DENSE_RANK()`, `LAG()`, and `SUM() OVER()`
- Customer segmentation and retention analysis
- Revenue and estimated profitability calculations
- Power BI dashboard design and DAX
- Business insight communication and documentation

## Project Conclusion

This project demonstrates an end-to-end data analytics workflow, from SQL-based exploration and analysis to Power BI visualization and business recommendations.

It highlights the ability to answer business questions, calculate meaningful KPIs, analyze customer behavior, and communicate findings through interactive reporting.
