/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      [order_id]
      ,CAST([date_ordered] AS Date)
      ,[order_type]
     
  FROM [PH_PROD].[dbxx].[hi_orders]

  UNION

  SELECT 
      [order_id]
      ,CAST([date_ordered] AS Date)
      ,[order_type]
     
  FROM [PH_PROD].[dbxx].[orders]