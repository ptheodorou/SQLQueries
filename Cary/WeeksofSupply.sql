
SELECT 
	A.[item_id]
	,A.[Forecasted]
	,B.[Inventory On Hand]
	,(CONVERT(FLOAT, B.[Inventory On Hand])/CONVERT(FLOAT,A.[Forecasted])) AS [Weeks of Supply]
FROM 
/*** This subquery gets current week of forecast numbers ***/
(SELECT
      [item_id] AS [item_id]
      ,ROUND(SUM([units_projection]),0) AS [Forecasted]
  FROM [METRICS_SUMMARIES].[dbo].[Forecast]
  WHERE [Week] = DATEPART(week,GETDATE())
  GROUP BY [item_id]) AS A
			INNER JOIN
/***This is the total inventory on hand for the start of the week***/
(SELECT
		[item_id]
		,SUM([pieces_onhand]) AS [Inventory On Hand] 
FROM [METRICS_SUMMARIES].[dbo].[ItemLocations]
WHERE [Date] = '06/08/14'
GROUP BY [item_id]) AS B
		ON A.[item_id] = B.[item_id]
WHERE A.[Forecasted] > 0 
ORDER BY [Weeks of Supply]

