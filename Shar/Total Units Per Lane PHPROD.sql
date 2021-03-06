/****** Total Orders Shipped Per Lane in PHPROD  ******/
SELECT 
      --[if_tran_code]
      [USR_ID]
	  
	  ,CAST([activity_date] AS Date) AS [Date]
      --,LEFT([location_id_from],1) AS [Lane] 
      ,COUNT(DISTINCT([order_id])) AS [Orders]
	  ,sum(pieces) AS Units

      
  FROM 
		[PH_PROD].[dbxx].[if_transaction]
WHERE
		CAST([activity_Date] AS date) BETWEEN '01/01/2014' AND '07/08/2014'  AND [if_tran_code] = 'POP-PICK'  
GROUP BY 
		 CAST([activity_Date] AS date),[USR_ID], [pieces]
Order by		 
		[Units] Desc
