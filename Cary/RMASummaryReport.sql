/****** Script for SelectTopNRows command from SSMS  ******/
WITH RMA AS(SELECT
    A.Date
    ,COUNT(DISTINCT A.[Original Order ID]) AS [Total Reships]
    ,SUM(B.tot_to_pick) AS [Total Units]
FROM 
(SELECT     
    CAST(date_shipped AS DATE) AS [Date]
    ,[Original Order ID]
    ,[Order ID]
  FROM [Metrics Reports].[dbo].[reships] AS A
			 INNER JOIN
	   PH_PROD.dbxx.hi_orders AS C
			 ON A.[Original Order ID] = C.order_id
WHERE [Reship Reason] = 'Defective'
)AS A
INNER JOIN
(SELECT
	   po_num
	   ,tot_to_pick
FROM PH_PROD.dbxx.hi_orders) AS B
    ON A.[Order ID] = B.po_num
GROUP BY
    A.[Date])


SELECT
	Reships.[Date]
    ,DATEPART(week,Reships.Date) AS [WeekofYear]
    ,SUM(Shipped.Orders) AS [Total Shipped Orders]
    ,SUM(Shipped.Units) AS [Total Shipped Units]
    ,SUM(Reships.[Total Reships])AS [Total Orders Reshipped]
    ,SUM(Reships.[Total Units])  AS [Total Units Reshipped]
FROM
(SELECT
    [Date]
    ,[Total Reships]
    ,[Total Units]
FROM RMA) AS Reships
    INNER JOIN
(SELECT
    CAST(date_shipped AS DATE) AS [Date]
    ,COUNT(DISTINCT order_id) AS Orders
    ,SUM(tot_shipped) AS Units
FROM PH_PROD.dbxx.hi_orders
GROUP BY 
    CAST(date_shipped AS DATE))AS Shipped
    ON Reships.Date = Shipped.Date
WHERE Reships.Date >= '11/01/14'
GROUP BY
    Reships.[Date],DATEPART(week,Reships.Date)

