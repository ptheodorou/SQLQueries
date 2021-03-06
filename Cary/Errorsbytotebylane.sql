/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  CAST([activity_date] AS DATE) AS [Date]
      ,COUNT ( DISTINCT [order_id]) AS [Orders Affected]
      ,COUNT([item_id]) AS [Units Affected]
      ,[Tote]
      ,SUBSTRING([Item Location],1,1) AS [Lane]
  FROM [DataWarehouse].[dbo].[PickerErrorsRaw] AS A
				INNER JOIN 
		[Datawarehouse].dbo.SlotsForErrors AS B
			ON A.tote = B.BoxBarCode AND A.order_id = B.SecondaryLocationName
  WHERE CAST([activity_date] AS DATE) >= '09/29/14'
  GROUP BY CAST([activity_date] AS DATE) 
		,[Tote]
		,SUBSTRING([Item Location],1,1)