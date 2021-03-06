/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	   DateOrdered,
	   DateShipped,
	   TicketCreated
	  ,DATEPART(week,[DateOrdered]) AS [Week Ordered]
       ,DATEPART(week,[DateShipped]) AS [Week Shipped]
	  ,DATEPART(week,TicketCreated) AS [Week of RMA]
	  ,PowerhouseOrderID
       ,ProductSKU
	  ,DesignerID
	  ,TicketEmailAddress
	  ,PrimaryReason
       ,ReturnQuantity
	  ,StdPrice
	  ,StdUnitCost
	  ,TotalRefundAmount
	  ,ResolutionRequested
  FROM [Metrics Reports].[dbo].[RMADailyReports] AS A
			 LEFT JOIN
	   mas500_app.dbo.timItem AS B
			 ON A.ProductSKU = B.ItemID

