
SELECT
	[Order]
	,[Zone]
	,SUM([Picks]) AS [Total to Pick]
FROM 
(SELECT 
       [Orders].[order_id] AS [Order]
	   ,[Lines].[item_id]
	  ,CASE WHEN SUBSTRING([Loc].[location_id],3,2) in ('AA','AB','AC','BA','BB','BC')
			THEN  1 
			WHEN SUBSTRING([Loc].[location_id],3,2) in ('AD','AF','AE','BD','BF','BE')
			THEN 2
			WHEN SUBSTRING([Loc].[location_id],3,2) in ('AG','AH','AI','BG','BH','BI')
			THEN 3
			WHEN SUBSTRING([Loc].[location_id],3,2) in ('AJ','AK','AL','BJ','BK','BL')
			THEN 4
			END AS [Zone] 
	   ,[Lines].[pieces_ordered] AS [Picks]
  FROM [PH_PROD].[dbxx].[order_lines] AS [Lines]
				INNER JOIN
		[PH_PROD].[dbxx].[orders] AS [Orders]
				ON [Lines].[order_id] = [Orders].[order_id]
				INNER JOIN
		[PH_PROD].[dbxx].[item_location] AS [Loc]
				ON [Lines].[item_id] = [Loc].[item_id]
WHERE [Orders].[order_type] = 'PARTY'
AND SUBSTRING([Loc].[location_id],1,1) = 'D')AS A
GROUP BY [Order]
	,[Zone]
ORDER BY [Order]
