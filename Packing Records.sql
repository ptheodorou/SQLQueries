/****** Script for SelectTopNRows command from SSMS  ******/
DECLARE @splitshift as time
SET	@splitshift = '8:00 AM'

SELECT TOP 10
	UPPER(b.full_name) as full_name,
	count(a.usr_id) as total_packages,
	a.activity_date

FROM
(SELECT
		a.usr_id,
	  Case when 
			cast(activity_time as time) > @splitshift 
			then cast(activity_date as date) 
			else cast(dateadd (day, -1, activity_date) as date) 
			end as activity_date
	    
  FROM [PH_PROD].[dbxx].[if_transaction] as a
  WHERE a.if_tran_code in ('Verify', 'Verify-q')) as a
		LEFT JOIN
		[PH_PROD].[dbxx].[usrs] as b
			on a.usr_id = b.usr_id
	WHERE b.full_name is not null
  GROUP BY cast(a.activity_date as date), b.full_name
  ORDER BY Total_Packages desc

 SELECT TOP 10
	UPPER(a.full_name) as full_name,
	sum(a.tot_ordered) as Pieces,
	a.activity_date

FROM(
  SELECT
		c.full_name,
	  b.tot_ordered,
	  Case when 
			cast(activity_time as time) > @splitshift 
			then cast(activity_date as date) 
			else cast(dateadd (day, -1, activity_date) as date) 
			end as activity_date
	    
  FROM [PH_PROD].[dbxx].[if_transaction] as a
		LEFT JOIN
		[PH_PROD].[dbxx].[hi_orders] as b
				on a.order_id = b.order_id
		LEFT JOIN
		[PH_PROD].[dbxx].[usrs] as C
			on a.usr_id = C.usr_id

  WHERE a.if_tran_code in ('Verify', 'Verify-q') and C.full_name is not null)as a
  GROUP BY cast(a.activity_date as date), a.full_name
  ORDER BY Pieces desc