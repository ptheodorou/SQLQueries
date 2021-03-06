SELECT
	right(left(ZoneName,7),2) as lane
	,SUM([Time]) AS [Total Hours],
	date
FROM
(SELECT 
	  [PickerName]
	  ,ZoneName,
	  barcode
	  ,datediff( second, lag(EventDateTime)  OVER (PARTITION BY PickerName Order By EventDatetime),EventDateTime) /60./60.0 AS [Time],
	  CAST(EventDateTime AS DATE) as date
 FROM [LPPick].[dbo].[ScanEvents]
 WHERE CAST(EventDateTime AS DATE) between '07/28/14' and '9/19/2014' and barcode in ('BEGIN', 'END') and pickername not in ( 'unassigned')) AS A
 where barcode = 'END'
 GROUP BY right(left(ZoneName,7),2) , date
