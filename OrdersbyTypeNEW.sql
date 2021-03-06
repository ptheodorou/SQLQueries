
SELECT 
		CAST([date_ordered] AS DATE) 
		,[order_type]
		,Count([order_type]) AS [Orders]
		,SUM([tot_ordered])AS [Units]      
FROM 
		[PH_PROD].[dbxx].[hi_orders]
WHERE CAST([date_ordered] AS DATE) between '01/01/14' and '03/04/14'
GROUP BY 
		[order_type]
		,CAST([date_ordered] AS DATE)
ORDER BY CAST([date_ordered] AS DATE)
