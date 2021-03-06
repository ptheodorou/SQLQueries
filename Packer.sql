/****** Script for SelectTopNRows command from SSMS  ******/

declare @startdate as date ,
		@enddate as date

set @startdate = '4/11/2014'
set @enddate = '4/14/2014'

Select 
	v.if_tran_code,
	v.usr_id,
	count(v.usr_id) as 'Orders',
	sum(o.Pieces) as 'pieces'
FROM
	(SELECT 
		 order_id
		 ,[if_tran_code]
		 ,[usr_id]
		 ,[activity_date]
		 ,[activity_time]
      
  FROM [PH_PROD].[dbxx].[if_transaction] 
  where cast(activity_date as date) = @enddate and  if_tran_code in ('verify' ,'verify-q')) as V
  
  LEFT JOIN

	(SELECT 
      order_id,
	  Sum(pieces) as 'pieces'
      
  FROM [PH_PROD].[dbxx].[if_transaction] 
  where cast(activity_date as date) between dateadd(day, datediff( day, 0 ,@enddate),-4) and @enddate and if_tran_code = 'pop-pick'
  group By order_id) as O

  on v.order_id = o.Order_id
  group by if_tran_code , usr_id
  order by if_tran_code