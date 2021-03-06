SELECT
	Defectives.[Date]
	,[Defectives].[item_id]
	,Defectives.[Defectives Found]
	,[Verified Units].[Total Shipped]
FROM
(SELECT 
       CAST([activity_date] AS DATE) AS [Date]
      ,[item_id]
	  ,COUNT(item_id) AS [Defectives Found]
  FROM [PH_PROD].[dbxx].[exceptions2]
  WHERE exception_type = 'DEFECTIVE'
  AND CAST(activity_date AS DATE) >= '01/01/14'
  GROUP BY CAST([activity_date] AS DATE)
      ,[item_id]) AS [Defectives]
			LEFT JOIN
(SELECT
		CAST(T.activity_date AS DATE) AS [Date]
		,T.[item_id]
		,SUM(T.pieces) AS [Total Shipped]
FROM [PH_PROD].[dbxx].[if_transaction] AS T
			INNER JOIN
	[PH_PROD].[dbxx].[if_transaction] AS P
			ON T.[order_id] = P.[order_id]
WHERE P.if_tran_code = 'VERIFY'
AND T.[if_tran_code] = 'POP-PICK'
AND CAST(T.activity_date AS DATE) >= '01/01/14'
GROUP BY CAST(T.activity_date AS DATE)
		,T.[item_id]) AS [Verified Units]
		ON [Defectives].[Date] = [Verified Units].[Date] AND [Defectives].[item_id] = [Verified Units].[item_id]