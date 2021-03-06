DECLARE @StartTime AS TIME, @EndTime AS TIME;
SET @StartTime = '07:00'
SET @EndTime = '18:00'
SELECT
	 CAST([Inspected Orders].[Date] AS DATE) AS [Date]
	,ISNULL([Inspected Orders].[Orders],0) AS [ Inspected Totals] 
	,ISNULL([Non Inspected Orders].Orders,0) AS [Non Inspected Totals]
	,(ISNULL([Inspected Orders].Orders,0)+ISNULL([Non Inspected Orders].Orders,0)) AS [Total Orders]
	,ROUND((CAST(ISNULL([Inspected Orders].[Orders],0)AS FLOAT)/CAST(ISNULL([Inspected Orders].Orders,0)+ISNULL([Non Inspected Orders].Orders,0)AS FLOAT)),3)AS [Inspection Rate]
FROM
(SELECT
		CAST(O.date_shipped AS DATE)AS [Date]
		,COUNT(O.[order_id])AS [Orders]
      
FROM [PH_PROD].[dbxx].[if_transaction] AS I
			INNER JOIN 
	 [PH_PROD].[dbxx].[hi_orders] AS O
		ON I.[order_id] = O.[order_id]
WHERE [if_tran_code] = 'VERIFY'
AND CAST(date_shipped AS TIME)>= @StartTime 
and CAST(date_shipped AS TIME)<= @EndTime
GROUP BY CAST(date_shipped AS DATE)) AS [Inspected Orders]
		LEFT JOIN
(SELECT
		 CAST(O.date_shipped AS DATE)AS [Date]
		,COUNT(O.[order_id])AS [Orders]
      
FROM [PH_PROD].[dbxx].[if_transaction] AS I
		INNER JOIN 
	 [PH_PROD].[dbxx].[hi_orders] AS O
		ON I.[order_id] = O.[order_id]
WHERE [if_tran_code]  = 'VERIFY-Q'
AND CAST(date_shipped AS TIME)>= @StartTime 
and CAST(date_shipped AS TIME)<= @EndTime
GROUP BY CAST([date_shipped] AS DATE))AS [Non Inspected Orders]
		ON [Inspected Orders].[Date] = [Non Inspected Orders].[Date]
GROUP BY 
			 CAST([Inspected Orders].[Date] AS DATE)
	,[Inspected Orders].[Orders]
	,[Non Inspected Orders].Orders
ORDER BY [Date]