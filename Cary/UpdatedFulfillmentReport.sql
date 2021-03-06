/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
    [Date]
    ,order_id
    ,CASE WHEN route_code like 'STD%'
	   THEN 'Standard'
	   ELSE 'Expedited'
	   END AS [Shipping Type]
    ,ship_method
    ,date_shipped
    ,package_trace_id
    ,[Hours]
    ,[Bucket]
FROM
(SELECT  [Date]
      ,[order_id]
      ,[route_code]
      ,[ship_method]
      ,[date_shipped]
      ,[package_trace_id]
      ,[Hours]
      ,[Bucket]
  FROM [Metrics Reports].[dbo].[View_avgtimetofulfillorderreport]
  WHERE [Date] >= '01/04/15')AS A
