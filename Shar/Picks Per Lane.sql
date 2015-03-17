/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      COUNT(DISTINCT([order_id]))
      
      ,[pick_rule]
      ,CAST([date_created] AS Date)
	  
  FROM [PH_PROD].[dbxx].[hi_orders]
WHERE [pick_rule] = 'PTL-ZONE B' AND Cast([date_created] AS Date) = '07/7/2014'
GROUP BY [pick_rule],CAST([date_created] AS Date)--,COUNT(DISTINCT([order_id]))