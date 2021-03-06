SELECT
	[PickerName]
	,[ZoneName]
	,SUM([Time]) AS [Total Hours]
FROM
(SELECT 
	  [PickerName]
	  ,ZoneName
	  ,datediff( second, lag(EventDateTime)  OVER (PARTITION BY PickerName Order By EventDatetime),EventDateTime) /60./60.0 AS [Time]
 FROM [LPPick].[dbo].[ScanEvents]
 WHERE CAST(EventDateTime AS DATE) = '06/30/14') AS A
 GROUP BY [PickerName], [ZoneName] 
