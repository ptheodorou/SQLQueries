DECLARE @StartDate AS DATE, @EndDate AS DATE;
SET @StartDate =
SET @EndDate = 
SELECT
	A.[Date]
	,U.[full_name]
	,A.[Total Orders] AS [Orders Affected]
	,B.[Total Inspected Orders]
	,(CONVERT(FLOAT,A.[Total Orders])/CONVERT(FLOAT, B.[Total Inspected Orders])) AS [Error Rate] 
FROM
(SELECT  
	   CAST(O.[date_shipped] AS DATE) AS [Date]
	  ,T.[usr_id]
      ,COUNT([Original Order ID]) AS [Total Orders]
  FROM [METRICS_SUMMARIES].[dbo].[reships] AS R
				LEFT JOIN
		[PH_PROD].[dbxx].[hi_orders] AS O
				ON R.[Original Order ID] = O.[order_id]
				LEFT JOIN
		[PH_PROD].[dbxx].[if_transaction] AS T
				ON O.[order_id] = T.[order_id]
				INNER JOIN
		[PH_PROD].[dbxx].[usrs] AS U
				ON O.[shipped_usr_id] = U.[usr_id]			
	WHERE [Reship Reason] in ('Missing product','Shipment Never Received','Wrong Item Received')
	AND CAST(O.[date_shipped] AS DATE) between @StartDate and @EndDate
	AND T.[if_tran_code] = 'VERIFY'
GROUP BY CAST(O.[date_shipped] AS DATE) 
	  ,T.[usr_id]) AS A
		INNER JOIN

(
SELECT 
	CAST(activity_date AS DATE) AS [Date]
	,[usr_id]
	,SUM(CONVERT(INT,[Tot_Orders])) AS [Total Inspected Orders]
FROM [PH_PROD].[dbo].[vw_PackerProductivity]
WHERE CAST(activity_date AS DATE) between @StartDate AND @EndDate
AND if_tran_code = 'VERIFY'
GROUP BY 	CAST(activity_date AS DATE) 
	,[usr_id]) AS B
	ON A.[Date] = B.[Date] AND A.[usr_id] = B.[usr_id]
		INNER JOIN
[PH_PROD].[dbxx].[usrs] AS U
		ON A.[usr_id] = U.[usr_id]