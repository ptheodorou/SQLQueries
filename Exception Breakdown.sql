/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	a.date,
	a.orders,
	a.units,
	b.[orders effected],
	b.[Units Effected]
FROM(
SELECT
      cast([date_shipped] as date) as Date,
	  count(cast([date_shipped] as date)) as Orders
      
      ,sum([tot_ordered]) as Units
      
  FROM [PH_PROD].[dbxx].[hi_orders]
  group by cast([date_shipped] as date)) as a

  LEFT JOIN
  
  (SELECT

cast([activity_date] as date) as date,
   count(distinct order_id) as 'Orders Effected',
		count(order_id) as 'Units Effected'

  FROM [PH_PROD].[dbxx].[exceptions2]
  WHERE screen_id = 'W_CARTON_PICKVERIFY_SHIP_POP_EXCEPTION'
  GROUP BY cast([activity_date] as date)) as b
  on	a.date = b.date
  ORDER BY a.date desc


  SELECT
  cast([activity_date] as date) as date,
  exception_type,
  Count(exception_type) as Total
  FROM[PH_PROD].[dbxx].[exceptions2]
  WHERE screen_id = 'W_CARTON_PICKVERIFY_SHIP_POP_EXCEPTION'
  GROUP BY cast([activity_date] as date), exception_type
  ORDER BY cast([activity_date] as date) desc