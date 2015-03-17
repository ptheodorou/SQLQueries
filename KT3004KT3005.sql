/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
    a.order_id,
     count(a. item_id)
      
  FROM [PH_PROD].[dbxx].[order_lines] as b
  join [PH_PROD].[dbxx].[order_lines] as a
  on a.order_id = b.Order_ID
  where b.item_id in ('kt3008')
  group by a.Order_id