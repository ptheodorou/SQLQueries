/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  
		[Date]
		,[group1]
		,[Total_orders]
FROM


(SELECT
      COUNT([order_id]) AS [Total_orders]
	  ,CAST([date_ordered] AS Date) AS [Date]
      ,[group1]
  FROM [PH_PROD].[dbxx].[hi_orders]
  WHERE [order_type] = 'Party' AND CAST([date_ordered] AS Date) BETWEEN '01/01/2014' AND '01/31/2014'
  GROUP BY CAST([date_ordered] AS Date) 
      ,[group1])  AS A
	  where Total_orders < 4
	  ORDER BY [date]
  
