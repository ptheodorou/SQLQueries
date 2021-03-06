/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
	   [Reship Reason]
       ,COUNT([Original Order ID]) AS [Orders] 
  FROM [METRICS_SUMMARIES].[dbo].[reships] AS R
				INNER JOIN
		[PH_PROD].[dbxx].[hi_orders] AS O
				ON R.[Original Order ID] = O.[order_id]
WHERE CAST(date_shipped AS DATE) between '06/01/14' and '06/07/14'
  GROUP BY   
	   [Reship Reason]
ORDER BY [Reship Reason]