SELECT 
	[Forecast].[Week]
	,[Forecast].[item_id]
	,[Forecast].[Projection]

FROM
(SELECT
	   [Week]
      ,[item_id]
      ,ROUND([units_projection],0) AS [Projection]
  FROM [METRICS_SUMMARIES].[dbo].[Forecast] AS F
  WHERE [Week] between DATENAME(week,GETDATE()) AND (DATENAME(week, GETDATE())+7)) AS Forecast
				LEFT JOIN
(SELECT
		[item_id]
		,SUM(pieces_onhand) AS [Inventory On Hand]
FROM [METRICS_SUMMARIES].[dbo].[ItemLocations]
WHERE [Date] = '06/08/14'
GROUP BY [item_id]) AS [On Hand]
		ON [Forecast].[item_id] = [On Hand].[item_id]

