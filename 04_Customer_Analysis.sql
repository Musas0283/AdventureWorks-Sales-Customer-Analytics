
/*
=========================================================
PROJECT: AdventureWorks Sales Performance & Customer Analytics
FILE: 04_Customer_Analysis.sql
DATABASE: AdventureWorks2022

OBJECTIVE:
Analyze customer purchasing behavior, identify
high-value customers, measure revenue contribution,
and evaluate customer acquisition and retention.
=========================================================
*/


/*
Challenge 20: Top 10 Customers by Order Frequency

Business Question:
Which 10 customers placed the highest number of
sales orders, and how much revenue did they generate?

Purpose:
Identify the most frequent purchasing customers
and evaluate their total revenue and average
order value.

SQL Techniques:
TOP, INNER JOIN, COUNT(DISTINCT),
SUM(), AVG(), GROUP BY, and ORDER BY.
*/

SELECT TOP 10
    SC.CustomerID,
    COUNT(DISTINCT SH.SalesOrderID) AS NumberofOrders,
    SUM(SH.SubTotal) AS Revenue,
    AVG(SH.SubTotal) AS AverageOrderValue
FROM Sales.Customer AS SC
INNER JOIN Sales.SalesOrderHeader AS SH
    ON SC.CustomerID = SH.CustomerID
GROUP BY
    SC.CustomerID
ORDER BY
    NumberofOrders DESC;


/*
Challenge 21: Top 10 Customers by Revenue

Business Question:
Which 10 customers generated the highest total
merchandise revenue?

Purpose:
Identify the most valuable customers based on
total revenue and compare their order frequency
and average order value.

SQL Techniques:
TOP, INNER JOIN, SUM(), COUNT(DISTINCT),
AVG(), GROUP BY, and ORDER BY.
*/

SELECT TOP 10
    SC.CustomerID,
    SUM(SH.SubTotal) AS Revenue,
    COUNT(DISTINCT SH.SalesOrderID) AS NumberofOrders,
    AVG(SH.SubTotal) AS AverageOrderValue
FROM Sales.Customer AS SC
INNER JOIN Sales.SalesOrderHeader AS SH
    ON SC.CustomerID = SH.CustomerID
GROUP BY
    SC.CustomerID
ORDER BY
    Revenue DESC;


/*
Challenge 22: Customer Revenue Segmentation

Business Question:
How can customers be classified into high,
medium, and low-value segments based on
their total merchandise revenue?

Purpose:
Categorize customers by purchasing value
to support targeted customer strategies.

Segmentation Rules:
High Value   : Revenue >= $100,000
Medium Value : Revenue >= $10,000 and < $100,000
Low Value    : Revenue < $10,000

SQL Techniques:
CTE, CASE, SUM(), INNER JOIN,
GROUP BY, and ORDER BY.
*/

WITH CaseCTE AS (
    SELECT
        SC.CustomerID,
        SUM(SH.SubTotal) AS Revenue
    FROM Sales.Customer AS SC
    INNER JOIN Sales.SalesOrderHeader AS SH
        ON SC.CustomerID = SH.CustomerID
    GROUP BY
        SC.CustomerID
)
SELECT
    CustomerID,
    Revenue,
    CASE
        WHEN Revenue >= 100000 THEN 'High Value'
        WHEN Revenue >= 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS CustomerRevenueSegment
FROM CaseCTE
ORDER BY
    Revenue DESC;


/*
Challenge 23: Revenue Contribution by Customer Segment

Business Question:
How much total revenue does each customer segment
generate, and what percentage of overall revenue
does each segment contribute?

Purpose:
Measure the financial importance of high,
medium, and low-value customer segments.

SQL Techniques:
Multiple CTEs, CASE, SUM(),
COUNT(DISTINCT), GROUP BY, and scalar subquery.

Calculation:
Revenue Contribution (%) =
Segment Revenue / Total Revenue * 100
*/

WITH CaseCTE AS (
    SELECT
        SC.CustomerID,
        SUM(SH.SubTotal) AS Revenue
    FROM Sales.Customer AS SC
    INNER JOIN Sales.SalesOrderHeader AS SH
        ON SC.CustomerID = SH.CustomerID
    GROUP BY
        SC.CustomerID
),
SecondStep AS (
    SELECT
        CustomerID,
        Revenue,
        CASE
            WHEN Revenue >= 100000 THEN 'High Value'
            WHEN Revenue >= 10000 THEN 'Medium Value'
            ELSE 'Low Value'
        END AS CustomerRevenueSegment
    FROM CaseCTE
),
ThirdStep AS (
    SELECT
        CustomerRevenueSegment,
        SUM(Revenue) AS SegmentRevenue,
        COUNT(DISTINCT CustomerID) AS NofCustomer
    FROM SecondStep
    GROUP BY
        CustomerRevenueSegment
)
SELECT
    CustomerRevenueSegment,
    SegmentRevenue,
    NofCustomer,
    (SegmentRevenue /
        NULLIF((SELECT SUM(SegmentRevenue)
                FROM ThirdStep), 0)) * 100
        AS [Revenue Contribution (%)]
FROM ThirdStep
ORDER BY
    SegmentRevenue DESC;


/*
Challenge 24: Ranking Customers by Revenue

Business Question:
Who are the top 10 customers ranked by
total merchandise revenue?

Purpose:
Rank customers based on their revenue
contribution and identify the highest-value
customers in the business.

SQL Techniques:
CTE, SUM(), INNER JOIN, GROUP BY,
TOP, and DENSE_RANK() window function.
*/

WITH Ranking_CTE AS (
    SELECT
        SC.CustomerID,
        SUM(SH.SubTotal) AS Revenue
    FROM Sales.Customer AS SC
    INNER JOIN Sales.SalesOrderHeader AS SH
        ON SC.CustomerID = SH.CustomerID
    GROUP BY
        SC.CustomerID
)
SELECT TOP 10
    CustomerID,
    Revenue,
    DENSE_RANK() OVER (
        ORDER BY Revenue DESC
    ) AS Customer_Revenue_Rank
FROM Ranking_CTE
ORDER BY
    Revenue DESC;


/*
Challenge 25: Top 10 Customers' Revenue Contribution

Business Question:
What percentage of total merchandise revenue
is contributed by each of the top 10 customers?

Purpose:
Measure the revenue concentration among
the highest-value customers.

SQL Techniques:
CTE, scalar subquery, SUM(), TOP,
DENSE_RANK(), and arithmetic calculations.

Calculation:
Customer Revenue Contribution (%) =
Customer Revenue / Total Customer Revenue * 100
*/

WITH Percent_Ranking_CTE AS (
    SELECT
        SC.CustomerID,
        SUM(SH.SubTotal) AS Revenue
    FROM Sales.Customer AS SC
    INNER JOIN Sales.SalesOrderHeader AS SH
        ON SC.CustomerID = SH.CustomerID
    GROUP BY
        SC.CustomerID
)
SELECT TOP 10
    CustomerID,
    Revenue,
    DENSE_RANK() OVER (
        ORDER BY Revenue DESC
    ) AS Customer_Revenue_Rank,
    (Revenue /
        NULLIF((SELECT SUM(Revenue)
                FROM Percent_Ranking_CTE), 0)) * 100
        AS [Revenue Contribution (%)]
FROM Percent_Ranking_CTE
ORDER BY
    Revenue DESC;


/*
Challenge 26: Revenue Contribution Using Window Functions

Business Question:
How can the revenue contribution of the top 10
customers be calculated using a window function?

Purpose:
Demonstrate an alternative method for calculating
each customer's percentage contribution to
overall merchandise revenue.

SQL Techniques:
CTE, SUM() OVER(), DENSE_RANK(),
TOP, and ORDER BY.

Calculation:
Revenue Contribution (%) =
Customer Revenue / Total Revenue * 100

Note:
SUM(Revenue) OVER() calculates total revenue
across all customers before TOP 10 is applied.
*/

WITH Percent_Ranking_CTE AS (
    SELECT
        SC.CustomerID,
        SUM(SH.SubTotal) AS Revenue
    FROM Sales.Customer AS SC
    INNER JOIN Sales.SalesOrderHeader AS SH
        ON SC.CustomerID = SH.CustomerID
    GROUP BY
        SC.CustomerID
)
SELECT TOP 10
    CustomerID,
    Revenue,
    DENSE_RANK() OVER (
        ORDER BY Revenue DESC
    ) AS Customer_Revenue_Rank,
    (Revenue /
        NULLIF(SUM(Revenue) OVER (), 0)) * 100
        AS [Revenue Contribution (%)]
FROM Percent_Ranking_CTE
ORDER BY
    Revenue DESC;


/*
Challenge 27: Average Revenue per Customer by Year

Business Question:
What is the average merchandise revenue generated
per purchasing customer each year?

Purpose:
Evaluate annual customer revenue performance
and compare revenue generated per active customer.

SQL Techniques:
CTE, YEAR(), COUNT(DISTINCT),
SUM(), GROUP BY, and ORDER BY.

Calculation:
Average Revenue per Customer =
Annual Revenue / Unique Purchasing Customers

Note:
This measures revenue per purchasing customer,
not average revenue per sales order.
*/

WITH FirstCTE AS (
    SELECT
        YEAR(OrderDate) AS Years,
        COUNT(DISTINCT CustomerID) AS NofCustomer,
        SUM(SubTotal) AS Revenue
    FROM Sales.SalesOrderHeader
    GROUP BY
        YEAR(OrderDate)
)
SELECT
    Years,
    NofCustomer,
    Revenue,
    Revenue / NULLIF(NofCustomer, 0) AS AVGCustomerRevenue
FROM FirstCTE
ORDER BY
    Years;


/*
Challenge 28: New vs. Returning Customers by Year

Business Question:
How many customers are new versus returning
in each purchasing year?

Purpose:
Analyze customer acquisition and repeat
purchasing behavior across years.

SQL Techniques:
Multiple CTEs, MIN(), YEAR(),
DISTINCT, CASE, JOIN, and GROUP BY.

Customer Classification:
New       : Purchasing year equals first purchase year
Returning : Purchasing year is after first purchase year

Note:
Each customer is counted once per purchasing year.
*/

WITH FirstCTE AS (
    SELECT
        CustomerID,
        MIN(OrderDate) AS FirstPurchase
    FROM Sales.SalesOrderHeader
    GROUP BY
        CustomerID
),
SecondCTE AS (
    SELECT DISTINCT
        FC.CustomerID,
        YEAR(FC.FirstPurchase) AS FirstPurchaseYear,
        YEAR(SS.OrderDate) AS PurchaseYear
    FROM Sales.SalesOrderHeader AS SS
    INNER JOIN FirstCTE AS FC
        ON FC.CustomerID = SS.CustomerID
),
ThirdCTE AS (
    SELECT
        CustomerID,
        PurchaseYear,
        CASE
            WHEN FirstPurchaseYear = PurchaseYear
                THEN 'New'
            ELSE 'Returning'
        END AS CustomerStatus
    FROM SecondCTE
)
SELECT
    PurchaseYear,
    SUM(CASE WHEN CustomerStatus = 'New'
             THEN 1 ELSE 0 END) AS NewCustomers,
    SUM(CASE WHEN CustomerStatus = 'Returning'
             THEN 1 ELSE 0 END) AS ReturningCustomers,
    COUNT(DISTINCT CustomerID) AS TotalCustomers
FROM ThirdCTE
GROUP BY
    PurchaseYear
ORDER BY
    PurchaseYear;


/*
Challenge 29: Customer Retention from 2012 to 2013

Business Question:
What percentage of customers who purchased
in 2012 returned to make a purchase in 2013?

Purpose:
Measure customer retention between two
consecutive years to evaluate repeat
purchasing behavior.

SQL Techniques:
CTEs, DISTINCT, INNER JOIN, YEAR(),
COUNT(), scalar subqueries, and ROUND().

Calculation:
Retention Rate (%) =
Retained Customers / Customers in 2012 * 100
*/

WITH FirstCTE AS (
    SELECT DISTINCT
        CustomerID
    FROM Sales.SalesOrderHeader
    WHERE YEAR(OrderDate) = 2012
),
SecondCTE AS (
    SELECT DISTINCT
        SH.CustomerID
    FROM FirstCTE AS FC
    INNER JOIN Sales.SalesOrderHeader AS SH
        ON FC.CustomerID = SH.CustomerID
    WHERE YEAR(SH.OrderDate) = 2013
)
SELECT
    (SELECT COUNT(*) FROM FirstCTE) AS Customers2012,
    (SELECT COUNT(*) FROM SecondCTE) AS RetainedCustomers,
    ROUND(
        (SELECT COUNT(*) FROM SecondCTE) * 100.0 /
        NULLIF((SELECT COUNT(*) FROM FirstCTE), 0),
        2
    ) AS RetentionRate;
