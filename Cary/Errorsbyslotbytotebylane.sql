SELECT
	[Date]
	,Lane
	,[Tote]
	,[Slot]
	,COUNT(DISTINCT Zone) AS [Number of Zones]
	,COUNT(DISTINCT order_id) AS [Orders with Errors]
	,COUNT(item_id) AS [Units with Errors]
FROM
(SELECT CAST([activity_date]AS DATE) AS [Date]
      ,[order_id] 
      ,[item_id] 
      ,[Tote]
      ,SUBSTRING([Item Location],1,1) AS [Lane]
	  ,DisplayAttribute AS [Slot]
	  ,CASE WHEN SUBSTRING([Item Location],4,1) in ('A','B','C')
			THEN 1
			WHEN SUBSTRING([Item Location],4,1) in ('D','E','F')
			THEN 2
			WHEN SUBSTRING([Item Location],4,1) in ('G','H','I')
			THEN 3
			WHEN SUBSTRING([Item Location],4,1) in ('J','K','L')
			THEN 4
			END AS [Zone]
  FROM 
		[DataWarehouse].[dbo].[PickerErrorsRaw] AS A
			INNER JOIN 
		[Datawarehouse].dbo.SlotsForErrors AS B
			ON A.tote = B.BoxBarCode AND A.order_id = B.SecondaryLocationName
  WHERE 
		exception_type in ('MISSING','WRONG ITEM','EXTRA ITEM')
		AND CAST([activity_date]AS DATE) >= '06/01/14') AS A
	GROUP BY [Date]
	,Lane
	,[Tote]
	,Slot
