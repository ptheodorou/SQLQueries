/**Total KIT's Ordered****/
SELECT 
      COUNT([order_id])
     ,[item_id]
      
  FROM [PH_PROD].[dbxx].[if_transaction]
  

  WHERE CAST(activity_date AS Date) = '6/4/2014' AND [item_id] LIKE 'kt%'

  Group BY [item_id]
  