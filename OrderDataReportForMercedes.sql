/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
       [order_id]
      ,[s_state]
      ,[date_ordered]
      ,[cust_id]
      ,[total_value]
      ,[po_num]
  FROM [PH_PROD].[dbxx].[hi_orders]
  WHERE CAST(date_ordered AS DATE) Between @StartDate and @EndDate

  UNION ALL

  SELECT 
       [order_id]
      ,[s_state]
      ,[date_ordered]
      ,[cust_id]
      ,[total_value]
      ,[po_num]
  FROM [PH_PROD].[dbxx].[orders]
  WHERE CAST(date_ordered AS DATE) Between @StartDate and @EndDate