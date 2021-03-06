/****** Script for SelectTopNRows command from SSMS  ******/
DECLARE @splitshift as time
SET	@splitshift = '7:00 AM'

SELECT TOP 10
	b.pickername,
	a.Pieces_picked,
	  a.[date]
FROM
(SELECT
	a.usr_id,
	SUM(a.pieces) as Pieces_picked,
	  a.[date]
FROM
(SELECT
      usr_id,
	  pieces,
	  Case when 
			cast(activity_time as time) > @splitshift 
			then cast(activity_date as date) 
			else cast(dateadd (day, -1, activity_date) as date) 
			end as [Date]

      
      
  FROM [PH_PROD].[dbxx].[if_transaction]
  WHERE if_tran_code = 'pop-pick' and usr_id <> 'LTNPICK') as a
  GROUP BY a.usr_id, a.date) as a
	LEFT JOIN
	[LPPICK].[dbo].[Pickers] as b
	on a.usr_id = b.PickerBarCode
WHERE pickername is not null
	ORDER BY a.pieces_picked desc