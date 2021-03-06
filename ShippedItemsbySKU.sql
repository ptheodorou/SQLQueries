DECLARE @startdate DATE
DECLARE @enddate DATE
SET @startdate = CAST('11/01/2014' AS DATE);
SET @enddate = CAST('11/11/2014' AS DATE);
SELECT CAST(O.[date_ordered]AS DATE) AS [Date Ordered]
       ,L.[item_id]
      ,SUM(L.[pieces_ordered]) AS [Total Ordered]
  FROM   
	[PH_PROD].[dbxx].[hi_orders] AS O
	 LEFT JOIN
	[PH_PROD].[dbxx].[hi_order_lines] AS L
  ON O.[order_id] = L.[order_id]
  WHERE CAST(O.[date_ordered]AS DATE) between @startdate and @enddate AND [item_id] IN ('LK4002')
  GROUP BY
		CAST(O.[date_ordered] AS DATE)
		,L.[item_id]
  ORDER BY CAST(O.[date_ordered] AS DATE) 