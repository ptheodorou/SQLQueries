/****** Total Orders Shipped Per Lane in PHPROD  ******/
SELECT 
      [if_tran_code]
      ,CAST([activity_date] AS Date) AS [Date]
      ,LEFT([location_id_from],1) AS [Lane] 
      ,COUNT(DISTINCT([order_id])) AS [Orders]
      
  FROM 
		[PH_PROD].[dbxx].[if_transaction]
WHERE
		CAST([activity_Date] AS date) BETWEEN '07/01/2014' AND '07/08/2014'  AND [if_tran_code] = 'POP-PICK' AND LEFT([location_id_from],1) IN ('A' ,'B')
GROUP BY 
		 CAST([activity_Date] AS date),[if_tran_code], LEFT([location_id_from],1)