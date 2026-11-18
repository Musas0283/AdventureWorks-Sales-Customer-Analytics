
/*
=========================================================
PROJECT: AdventureWorks Sales Performance & Customer Analytics
FILE: 03_Product_Performance_Analysis.sql
DATABASE: AdventureWorks2022

OBJECTIVE:
Analyze product and category sales performance,
estimate product profitability, and evaluate
gross profit margins to identify the strongest
revenue and profit contributors.
=========================================================
*/


/*
Challenge 14: Top 10 Products by Quantity Sold

Business Question:
Which 10 products have the highest total units sold,
and how much revenue do they generate?

Purpose:
Identify the most popular products based on sales
volume and compare their revenue contributions.

SQL Techniques:
TOP, INNER JOIN, SUM(), COUNT(DISTINCT),
GROUP BY, and ORDER BY.
*/

SELECT TOP 10
    PP.Name AS ProductName,
    SUM(SD.OrderQty) AS Total_quantity_sold,
    SUM(SD.LineTotal) AS Total_Revenue,
    COUNT(DISTINCT SD.SalesOrderID) AS Total_Number_SalesOrders
FROM Sales.SalesOrderDetail AS SD
INNER JOIN Production.Product AS PP
    ON SD.ProductID = PP.ProductID
GROUP BY
    PP.ProductID,
    PP.Name
ORDER BY
    Total_quantity_sold DESC;


/*
Challenge 15: Product Category Sales Performance

Business Question:
How much revenue does each product category generate,
and how do categories compare in units sold and
sales order volume?

Purpose:
Evaluate sales performance across product categories
to identify major contributors to total revenue.

SQL Techniques:
Multiple INNER JOINs, SUM(), COUNT(DISTINCT),
GROUP BY, and ORDER BY.
*/

SELECT
    PC.Name AS CategoryName,
    SUM(SD.LineTotal) AS Total_Revenue,
    SUM(SD.OrderQty) AS Total_quantity_sold,
    COUNT(DISTINCT SD.SalesOrderID) AS Total_Number_SalesOrders
FROM Production.ProductCategory AS PC
INNER JOIN Production.ProductSubcategory AS PS
    ON PC.ProductCategoryID = PS.ProductCategoryID
INNER JOIN Production.Product AS PP
    ON PS.ProductSubcategoryID = PP.ProductSubcategoryID
INNER JOIN Sales.SalesOrderDetail AS SD
    ON PP.ProductID = SD.ProductID
GROUP BY
    PC.ProductCategoryID,
    PC.Name
ORDER BY
    Total_Revenue DESC;


/*
Challenge 16: Top 10 Product Subcategories by Revenue

Business Question:
Which 10 product subcategories generate the highest
revenue, and how do their quantities sold and
sales order volumes compare?

Purpose:
Identify high-performing product subcategories
and understand their contribution to overall
category sales performance.

SQL Techniques:
TOP, multiple INNER JOINs, SUM(),
COUNT(DISTINCT), GROUP BY, and ORDER BY.
*/

SELECT TOP 10
    PC.Name AS CategoryName,
    PS.Name AS ProductSubCategoryName,
    SUM(SD.LineTotal) AS Total_Revenue,
    SUM(SD.OrderQty) AS Total_quantity_sold,
    COUNT(DISTINCT SD.SalesOrderID) AS Total_Number_SalesOrders
FROM Production.ProductCategory AS PC
INNER JOIN Production.ProductSubcategory AS PS
    ON PC.ProductCategoryID = PS.ProductCategoryID
INNER JOIN Production.Product AS PP
    ON PS.ProductSubcategoryID = PP.ProductSubcategoryID
INNER JOIN Sales.SalesOrderDetail AS SD
    ON PP.ProductID = SD.ProductID
GROUP BY
    PC.ProductCategoryID,
    PC.Name,
    PS.ProductSubcategoryID,
    PS.Name
ORDER BY
    Total_Revenue DESC;


/*
Challenge 17: Top 10 Products by Estimated Profit

Business Question:
Which 10 products generate the highest estimated
gross profit based on merchandise revenue and
standard product cost?

Purpose:
Identify products contributing the greatest
estimated profit rather than revenue alone.

SQL Techniques:
CTE, SUM(), arithmetic calculations,
TOP, GROUP BY, and ORDER BY.

Calculation:
Estimated Profit = Total Revenue - Estimated Cost

Limitation:
Estimated cost uses the current StandardCost
stored in Production.Product, rather than
historical costs at the time of each sale.
*/

WITH RevenueCTE AS (
    SELECT
        PP.ProductID,
        PP.Name AS ProductName,
        SUM(SD.OrderQty) AS TotalQuantity,
        SUM(SD.OrderQty * PP.StandardCost) AS EstimatedCost,
        SUM(SD.LineTotal) AS Total_Revenue
    FROM Sales.SalesOrderDetail AS SD
    INNER JOIN Production.Product AS PP
        ON SD.ProductID = PP.ProductID
    GROUP BY
        PP.ProductID,
        PP.Name
)
SELECT TOP 10
    ProductName,
    TotalQuantity,
    EstimatedCost,
    Total_Revenue,
    (Total_Revenue - EstimatedCost) AS Profit
FROM RevenueCTE
ORDER BY
    Profit DESC;


/*
Challenge 18: Top 10 Products by Estimated Gross Profit Margin

Business Question:
Which 10 products have the highest estimated
gross profit margins?

Purpose:
Evaluate product profitability as a percentage
of revenue and identify products with the
strongest estimated margins.

SQL Techniques:
CTE, HAVING, SUM(), arithmetic calculations,
TOP, GROUP BY, and ORDER BY.

Calculation:
Gross Profit Margin (%) =
((Total Revenue - Estimated Cost) / Total Revenue) * 100

Limitation:
Margins are estimates based on current standard
product costs, not historical transaction costs.
*/

WITH RevenueCTE AS (
    SELECT
        PP.ProductID,
        PP.Name AS ProductName,
        SUM(SD.OrderQty) AS TotalQuantity,
        SUM(SD.OrderQty * PP.StandardCost) AS EstimatedCost,
        SUM(SD.LineTotal) AS Total_Revenue
    FROM Sales.SalesOrderDetail AS SD
    INNER JOIN Production.Product AS PP
        ON SD.ProductID = PP.ProductID
    GROUP BY
        PP.ProductID,
        PP.Name
    HAVING SUM(SD.LineTotal) > 0
)
SELECT TOP 10
    ProductName,
    TotalQuantity,
    EstimatedCost,
    Total_Revenue,
    (Total_Revenue - EstimatedCost) AS Profit,
    ((Total_Revenue - EstimatedCost) /
        NULLIF(Total_Revenue, 0)) * 100
        AS [GrossProfitMargin (%)]
FROM RevenueCTE
ORDER BY
    [GrossProfitMargin (%)] DESC;


/*
Challenge 19: Estimated Gross Profit by Product Category

Business Question:
Which product categories generate the highest
estimated gross profit, and how do their
gross profit margins compare?

Purpose:
Compare category-level profitability to identify
which product groups contribute the most
estimated gross profit.

SQL Techniques:
CTE, multiple INNER JOINs, SUM(),
HAVING, GROUP BY, and ORDER BY.

Calculations:
Estimated Gross Profit = Total Revenue - Estimated Cost

Gross Profit Margin (%) =
(Estimated Gross Profit / Total Revenue) * 100

Limitation:
Estimated costs use current product standard
costs and may differ from historical actual costs.
*/

WITH GrossprofitCTE AS (
    SELECT
        PC.Name AS CategoryName,
        SUM(SD.LineTotal) AS Total_Revenue,
        SUM(SD.OrderQty * PP.StandardCost) AS EstimatedCost
    FROM Production.ProductCategory AS PC
    INNER JOIN Production.ProductSubcategory AS PS
        ON PC.ProductCategoryID = PS.ProductCategoryID
    INNER JOIN Production.Product AS PP
        ON PS.ProductSubcategoryID = PP.ProductSubcategoryID
    INNER JOIN Sales.SalesOrderDetail AS SD
        ON PP.ProductID = SD.ProductID
    GROUP BY
        PC.ProductCategoryID,
        PC.Name
    HAVING SUM(SD.LineTotal) > 0
)
SELECT
    CategoryName,
    Total_Revenue,
    EstimatedCost,
    (Total_Revenue - EstimatedCost) AS GrossProfit,
    ((Total_Revenue - EstimatedCost) /
        NULLIF(Total_Revenue, 0)) * 100
        AS [GrossProfitMargin (%)]
FROM GrossprofitCTE
ORDER BY
    GrossProfit DESC;
