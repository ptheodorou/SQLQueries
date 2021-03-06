SELECT
	A.[Date]
	,C.[full_name]
	,A.[Total Orders] AS [Orders Affected]
	,B.[Total Inspected Orders] 
	,(CAST(A.[Total Orders] AS DECIMAL)/CAST(B.[Total Inspected Orders] AS DECIMAL)) AS [Error Rate]
FROM 
(SELECT  
	  DATENAME(month, CAST(O.[date_shipped] AS DATE)) AS [Date]
	  ,T.[usr_id] AS [Name]
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
	AND CAST(O.[date_shipped] AS DATE) >= '01/01/14'
	AND T.[if_tran_code] = 'VERIFY'
GROUP BY  DATENAME(month, CAST(O.[date_shipped] AS DATE))
	  ,T.[usr_id]) AS A
	LEFT JOIN 
(SELECT 
DATENAME(month,CAST(activity_date AS DATE)) AS [Date]
,usr_id AS [Name] 
,SUM(CONVERT(INT, Tot_Orders)) AS [Total Inspected Orders]
FROM [PH_PROD].[dbo].[vw_PackerProductivity]
WHERE [if_tran_code] = 'VERIFY'
AND CAST(activity_date AS DATE) >= '01/01/14'
GROUP BY DATENAME(month,CAST(activity_date AS DATE))
,usr_id) AS B
	ON A.[Date] =  B.[Date] AND A.[Name] = B.[Name]
	INNER JOIN
[PH_PROD].[dbxx].[usrs] AS C
	ON A.[Name] = C.[usr_id] 
Order By [Date]


