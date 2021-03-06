/****** Script for SelectTopNRows command from SSMS  ******/
With RMA AS(SELECT  
      [PowerhouseOrderID]
      ,[ProductSKU]
      ,[ReturnQuantity]
      ,[PrimaryReason]
      ,[TicketCreated]
      ,[LastUpdated]
	 ,C.date_shipped
	 ,C.shipped_usr_id
	 ,B.item_id
	 ,B.release_num
  FROM [Metrics Reports].[dbo].[RMAReportingData]AS A
			 INNER JOIN 
	   PH_PROD.dbxx.hi_order_lines AS B
			 ON A.PowerhouseOrderID = B.order_id AND A.ProductSKU = B.item_id
			 INNER JOIN
	   PH_PROD.dbxx.hi_orders AS C
			 On B.order_id = C.order_id AND B.release_num = C.release_num) 
SELECT
    Reships.[Start of Week]
    ,Reships.WeekofYear
    ,Reships.Orders AS [RMA Orders Requested]
    ,Shipments.Orders AS [Total Orders Shipped]
    ,(CAST(Reships.Orders AS DECIMAL)/CAST(Shipments.Orders AS DECIMAL)) AS [% Of Orders]
    ,Reships.Units AS [RMA Units Requested]
    ,Shipments.Units AS [Total Units Shipped]
    ,(CAST(Reships.Units AS DECIMAL)/CAST(Shipments.Units AS DECIMAL)) AS [% Of Units]
FROM
(SELECT
    DATEPART(week,date_shipped) AS [WeekofYear]
    ,MIN(CAST(date_shipped AS DATE)) AS [Start of Week]
    ,COUNT(DISTINCT PowerhouseOrderID) AS [Orders]
    ,SUM(ReturnQuantity) AS [Units]
FROM RMA
GROUP BY DATEPART(week,date_shipped))AS Reships
	   INNER JOIN
(SELECT
	DATEPART(week,date_shipped) AS [WeekofYear]
	,COUNT(order_id) AS [Orders]
	,SUM(tot_shipped) AS [Units]
FROM PH_PROD.dbxx.hi_orders
GROUP BY DATEPART(week,date_shipped)) AS [Shipments]
    ON Reships.WeekofYear = Shipments.WeekofYear
