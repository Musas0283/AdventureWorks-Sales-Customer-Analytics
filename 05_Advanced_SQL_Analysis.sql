
/*
=========================================================
PROJECT: AdventureWorks Sales Performance & Customer Analytics
FILE: 05_Advanced_SQL_Analysis.sql
DATABASE: AdventureWorks2022

OBJECTIVE:
Apply advanced SQL techniques to analyze customer
retention, lifetime revenue, and monthly sales growth.

KEY TECHNIQUES:
Common Table Expressions (CTEs), self-joins,
window functions, DENSE_RANK(), LAG(),
conditional calculations, and aggregations.
=========================================================
*/


/*
Challenge 30: Year-over-Year Customer Retention

Business Question:
What percentage of customers who purchased in one
year returned to make a purchase the following year?

Purpose:
Measure customer loyalty and repeat purchasing
behavior across consecutive years.

SQL Techniques:
CTEs, LEFT JOIN, YEAR(), COUNT(),
GROUP BY, ROUND(), and self-join.

Calculation:
Retention Rate (%) =
Retained Customers / Customers in Base Year * 100

Note:
The analysis evaluates purchasing cohorts from
2011 to 2013 and measures their retention in
the following year.
*/

WITH CustomerYears AS (
    -- Step 1: Identify unique customer-year combinations
    SELECT
        CustomerID,
        YEAR(OrderDate) AS PurchaseYear
    FROM Sales.SalesOrderHeader
    GROUP BY
        CustomerID,
        YEAR(OrderDate)
),
RetentionCTE AS (
    -- Step 2: Identify customers returning the following year
    SELECT
        A.CustomerID,
        A.PurchaseYear,
        B.CustomerID AS ReturningCustomer
    FROM CustomerYears AS A
    LEFT JOIN CustomerYears AS B
        ON A.CustomerID = B.CustomerID
        AND B.PurchaseYear = A.PurchaseYear + 1
)
-- Step 3: Calculate retention rate by purchasing year
SELECT
    PurchaseYear,
    COUNT(*) AS TotalCustomers,
    COUNT(ReturningCustomer) AS RetainedCustomers,
    ROUND(
        COUNT(ReturningCustomer) * 100.0 /
        NULLIF(COUNT(*), 0),
        2
    ) AS RetentionRate
FROM RetentionCTE
WHERE PurchaseYear BETWEEN 2011 AND 2013
GROUP BY
    PurchaseYear
ORDER BY
    PurchaseYear;


/*
Challenge 31: Customer Lifetime Revenue Analysis

Business Question:
How much total merchandise revenue has each
customer generated throughout their purchasing
history, and how do customers rank by revenue?

Purpose:
Identify high-value customers and analyze their
total orders, lifetime revenue, average order
value, and purchasing history.

SQL Techniques:
CTE, SUM(), COUNT(), MIN(), MAX(),
CAST(), DENSE_RANK(), and ORDER BY.

Calculations:
Lifetime Revenue = SUM(SubTotal)

Average Order Value =
Lifetime Revenue / Total Orders

Revenue Rank =
Customer ranking by lifetime revenue (descending)

Note:
Lifetime revenue represents revenue generated
within the available dataset, not a prediction
of future customer value.
*/

WITH CustomerRevenue AS (
    -- Step 1: Aggregate purchasing activity per customer
    SELECT
        CustomerID,
        COUNT(SalesOrderID) AS TotalOrders,
        SUM(SubTotal) AS LifetimeRevenue,
        MIN(OrderDate) AS FirstPurchaseDate,
        MAX(OrderDate) AS LastPurchaseDate
    FROM Sales.SalesOrderHeader
    GROUP BY
        CustomerID
)
-- Step 2: Calculate AOV and rank customers by revenue
SELECT
    CustomerID,
    TotalOrders,
    CAST(LifetimeRevenue AS DECIMAL(18,2))
        AS LifetimeRevenue,
    CAST(
        LifetimeRevenue / NULLIF(TotalOrders, 0)
        AS DECIMAL(18,2)
    ) AS AverageOrderValue,
    FirstPurchaseDate,
    LastPurchaseDate,
    DENSE_RANK() OVER (
        ORDER BY LifetimeRevenue DESC
    ) AS RevenueRank
FROM CustomerRevenue
ORDER BY
    LifetimeRevenue DESC;


/*
Challenge 32: Month-over-Month Sales Growth

Business Question:
How does total merchandise revenue change from
one month to the next across the sales dataset?

Purpose:
Measure monthly revenue growth and identify
periods of increasing or declining sales.

SQL Techniques:
CTEs, YEAR(), MONTH(), SUM(), LAG(),
NULLIF(), CAST(), and ORDER BY.

Calculation:
Monthly Growth (%) =
(Current Month Revenue - Previous Month Revenue)
 / Previous Month Revenue * 100

Note:
LAG() retrieves the previous available month
from the monthly aggregated sales results.

The first month has no previous-month comparison,
so its growth percentage is NULL.
*/

WITH MonthlySales AS (
    -- Step 1: Calculate total merchandise revenue by month
    SELECT
        YEAR(OrderDate) AS SalesYear,
        MONTH(OrderDate) AS SalesMonth,
        SUM(SubTotal) AS MonthlyRevenue
    FROM Sales.SalesOrderHeader
    GROUP BY
        YEAR(OrderDate),
        MONTH(OrderDate)
),
PreviousMonthSales AS (
    -- Step 2: Retrieve previous month's revenue
    SELECT
        SalesYear,
        SalesMonth,
        MonthlyRevenue,
        LAG(MonthlyRevenue) OVER (
            ORDER BY SalesYear, SalesMonth
        ) AS PreviousMonthRevenue
    FROM MonthlySales
)
-- Step 3: Calculate month-over-month revenue growth
SELECT
    SalesYear,
    SalesMonth,
    CAST(MonthlyRevenue AS DECIMAL(18,2))
        AS MonthlyRevenue,
    CAST(PreviousMonthRevenue AS DECIMAL(18,2))
        AS PreviousMonthRevenue,
    CAST(
        (MonthlyRevenue - PreviousMonthRevenue)
        * 100.0 /
        NULLIF(PreviousMonthRevenue, 0)
        AS DECIMAL(10,2)
    ) AS MonthlyGrowthPercentage
FROM PreviousMonthSales
ORDER BY
    SalesYear,
    SalesMonth;
