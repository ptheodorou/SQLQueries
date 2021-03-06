/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      [BoxBarCode]
	  ,[PickOrderId]
      ,[BoxInTime]
      ,[PickerId]
	  ,DATEDIFF(second,BoxInTime, GETDATE())/60.0/60.0 AS [Hours]
  FROM [LPPick].[dbo].[Boxes]
  WHERE BoxStatus = 0
  AND CAST(BoxInTime AS DATE) between DATEADD(day,-1,CAST(GETDATE() AS DATE)) AND CAST(GETDATE() AS DATE)