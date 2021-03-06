/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
		CAST([Login].[EventDateTime] AS DATE) AS [Date]
		,AVG(ABS(DATEDIFF(second, [login].[EventDateTime], [logout].[EventDateTime])/60.0/60.0))	
FROM
(SELECT [EventDateTime]
      ,[ZoneName]
      ,[Barcode]
      ,[PickerName]
      ,[PickerBarCode]
  FROM [LPPick].[dbo].[ScanEvents]
  WHERE [Barcode] = 'Begin')AS [Login]
					INNER JOIN
  (SELECT [EventDateTime]
      ,[ZoneName]
      ,[Barcode]
      ,[PickerName]
      ,[PickerBarCode]
  FROM [LPPick].[dbo].[ScanEvents]
  WHERE [Barcode]= 'End' )AS [logout]
			ON CAST([Login].[EventDateTime] AS DATE) = CAST([logout].[EventDateTime] AS DATE) AND [Login].[PickerBarCode] = [logout].[PickerBarCode]
WHERE CAST([Login].[EventDateTime] AS DATE) > '05/04/14'
GROUP BY CAST([Login].[EventDateTime] AS DATE)