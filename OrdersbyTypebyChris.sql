
Declare @startdate as date, @enddate as date

set @startdate = '2/01/2014'
set @enddate = '2/28/2014'


Select 
	order_type,
	sum(orders) as orders,
	sum(units) as units	
	FROM
(select 
	order_type,
	orders,
	units	
from
(SELECT 

		[order_type]
		,Count([order_type]) AS [Orders]
		,SUM([tot_ordered])AS [Units]      
FROM 
		[PH_PROD].[dbxx].[hi_orders]
			
WHERE CAST([date_ordered] AS DATE) between @startdate and @enddate
GROUP BY 
		[order_type]) as a
union

(SELECT 

		[order_type]
		,Count([order_type]) AS [Orders]
		,SUM([tot_ordered])AS [Units]      
FROM 
		[PH_PROD].[dbxx].[orders]
			
WHERE CAST([date_ordered] AS DATE) between @startdate and @enddate
GROUP BY 
		[order_type])) as a
		group by order_type

