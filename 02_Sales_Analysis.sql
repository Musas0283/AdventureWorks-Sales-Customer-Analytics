
/*
=========================================================
PROJECT: AdventureWorks Sales Performance & Customer Analytics
FILE: 02_Sales_Analysis.sql
DATABASE: AdventureWorks2022

OBJECTIVE:
Analyze sales performance across time periods,
sales territories, and products to identify revenue
trends and key business performance drivers.
=========================================================
*/


/*
Challenge 9: Monthly Sales Performance Analysis

Business Question:
How do total merchandise revenue and sales order
volume change from month to month across all years?

Purpose:
Identify monthly sales trends, seasonal patterns,
and changes in overall sales performance.

SQL Techniques:
YEAR(), MONTH(), DATENAME(), SUM(),
COUNT(DISTINCT), GROUP BY, and ORDER BY.
*/

SELECT
    YEAR(OrderDate) AS Years,
    DATENAME(MONTH, OrderDate) AS [Month],
    SUM(SubTotal) AS Total_Revenue,
    COUNT(DISTINCT SalesOrderID) AS Total_Number_SalesOrders
FROM Sales.SalesOrderHeader
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate),
    DATENAME(MONTH, OrderDate)
ORDER BY
    Years,
    MONTH(OrderDate);


/*
Challenge 10: Annual Sales Performance Analysis

Business Question:
How much merchandise revenue was generated each year,
how many sales orders were placed, and what was the
average revenue per order?

Purpose:
Evaluate year-over-year sales performance and
understand changes in annual order value.

SQL Techniques:
YEAR(), SUM(), COUNT(DISTINCT),
AVG(), GROUP BY, and ORDER BY.
*/

SELECT
    YEAR(OrderDate) AS Years,
    SUM(SubTotal) AS Total_Revenue,
    COUNT(DISTINCT SalesOrderID) AS Total_Number_SalesOrders,
    AVG(SubTotal) AS AverageRevenue
FROM Sales.SalesOrderHeader
GROUP BY
    YEAR(OrderDate)
ORDER BY
    Years;


/*
Challenge 11: Monthly Sales Performance for 2013

Business Question:
How did merchandise revenue, sales order volume,
and average order value vary across the months
of 2013?

Purpose:
Examine monthly sales performance within a
specific year to identify stronger and weaker
sales periods.

SQL Techniques:
DATENAME(), YEAR(), MONTH(), SUM(),
COUNT(DISTINCT), AVG(), WHERE, and GROUP BY.
*/

SELECT
    DATENAME(MONTH, OrderDate) AS Months,
    SUM(SubTotal) AS Total_Revenue,
    COUNT(DISTINCT SalesOrderID) AS Total_Number_SalesOrders,
    AVG(SubTotal) AS AverageOrderValue
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
GROUP BY
    MONTH(OrderDate),
    DATENAME(MONTH, OrderDate)
ORDER BY
    MONTH(OrderDate);


/*
Challenge 12: Sales Performance by Territory

Business Question:
Which sales territories generate the highest
merchandise revenue, and how do their order
volumes and average order values compare?

Purpose:
Evaluate geographic sales performance and
identify the territories contributing most
to overall business revenue.

SQL Techniques:
INNER JOIN, SUM(), COUNT(DISTINCT),
AVG(), GROUP BY, and ORDER BY.
*/

SELECT
    ST.Name AS TerritoryName,
    SUM(SS.SubTotal) AS Total_Revenue,
    COUNT(DISTINCT SS.SalesOrderID) AS Total_Number_SalesOrders,
    AVG(SS.SubTotal) AS AverageOrderValue
FROM Sales.SalesOrderHeader AS SS
INNER JOIN Sales.SalesTerritory AS ST
    ON SS.TerritoryID = ST.TerritoryID
GROUP BY
    ST.TerritoryID,
    ST.Name
ORDER BY
    Total_Revenue DESC;


/*
Challenge 13: Top 10 Products by Revenue

Business Question:
Which 10 products generate the highest merchandise
revenue, and what are their total quantities sold
and number of associated sales orders?

Purpose:
Identify top-performing products to support
product performance evaluation and sales
strategy decisions.

SQL Techniques:
TOP, INNER JOIN, SUM(), COUNT(DISTINCT),
GROUP BY, and ORDER BY.

Revenue Definition:
LineTotal represents merchandise revenue at
the sales order line level, excluding tax
and freight.
*/

SELECT TOP 10
    PP.Name AS ProductName,
    SUM(SD.LineTotal) AS Total_Revenue,
    SUM(SD.OrderQty) AS Total_quantity_sold,
    COUNT(DISTINCT SD.SalesOrderID) AS Total_Number_SalesOrders
FROM Sales.SalesOrderHeader AS SS
INNER JOIN Sales.SalesOrderDetail AS SD
    ON SS.SalesOrderID = SD.SalesOrderID
INNER JOIN Production.Product AS PP
    ON SD.ProductID = PP.ProductID
GROUP BY
    PP.ProductID,
    PP.Name
ORDER BY
    Total_Revenue DESC;
