
SELECT 
      I.[usr_id],
	  P.[PickerName]
      ,Cast(I.[activity_date] AS DATE) AS [Date]
      ,SUM(I.[pieces]) AS [Units Picked]
  FROM [PH_PROD].[dbxx].[if_transaction] AS I
  INNER JOIN [LPPick].[dbo].[Pickers]AS P
  ON I.[usr_id] = P.[PickerBarCode]
  WHERE I.[if_tran_code] = 'POP-PICK'
   AND I.[activity_date] = '02/13/2014'
	GROUP BY I.[usr_id],
	Cast([activity_date] AS DATE),
	P.[PickerName]
		
