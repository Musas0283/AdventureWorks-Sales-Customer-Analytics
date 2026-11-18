/*
Challenge 1: Total Sales Orders

Business Question:
How many sales orders were recorded in AdventureWorks?

Purpose:
Determine the total number of sales orders
to establish a baseline for sales analysis.
*/

SELECT COUNT(*) AS Nofsales
FROM Sales.SalesOrderHeader;

/*
Challenge 2: Total Sales Order Line Items

Business Question:
How many individual sales order line items
are recorded in AdventureWorks?

Purpose:
Determine the total number of products listed
across sales orders to understand transaction volume.
*/

SELECT COUNT(*) AS NofSalesOrderLineItem
FROM Sales.SalesOrderDetail;
/*
Challenge 3: Total Purchasing Customers

Business Question:
How many unique customers have placed at least
one order in AdventureWorks?

Purpose:
Identify the total number of purchasing customers
without counting repeat customers multiple times.
*/

SELECT COUNT(DISTINCT CustomerID) AS NofPurchasingCustomer
FROM [Sales].[SalesOrderHeader];

/*
Challenge 4: Sales Order Date Range

Business Question:
What are the earliest and latest sales order dates
recorded in AdventureWorks?

Purpose:
Identify the period covered by the sales dataset
to establish the timeframe for sales trend analysis.
*/

SELECT
    MIN(OrderDate) AS FirstPurchaseDate,
    MAX(OrderDate) AS LastPurchaseDate
FROM Sales.SalesOrderHeader;

/*
Challenge 5: Total Merchandise Revenue

Business Question:
What is the total merchandise revenue generated
by AdventureWorks?

Purpose:
Calculate total merchandise revenue excluding
tax and freight to evaluate overall sales performance.
*/

SELECT
    SUM(SubTotal) AS TotalMerchandiseRevenue
FROM Sales.SalesOrderHeader;

/*
Challenge 6: Total Products

Business Question:
How many products are recorded in AdventureWorks?

Purpose:
Determine the total number of products in the
database, including products without sales history.
*/

SELECT COUNT(*) AS NOfProducts
FROM Production.Product;

/*
Challenge 7: Product Categories and Subcategories

Business Question:
How many product categories and subcategories
are recorded in AdventureWorks?

Purpose:
Understand the structure of the product catalog
by counting the total categories and subcategories.

Technique:
Use independent scalar subqueries to return
two aggregate counts in a single result.
*/

SELECT
    (SELECT COUNT(*)
     FROM Production.ProductSubcategory) AS TotalSubcategories,

    (SELECT COUNT(*)
     FROM Production.ProductCategory) AS TotalCategories;

	 /*
Challenge 8: Total Sales Territories

Business Question:
How many sales territories are recorded
in the AdventureWorks database?

Purpose:
Determine the number of sales territories
represented in the database to understand
the geographic coverage of sales operations.
*/

SELECT
    COUNT(*) AS TotalSalesTerritories
FROM Sales.SalesTerritory;