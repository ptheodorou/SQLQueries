/****** Script for SelectTopNRows command from SSMS  ******/
SELECT P.[usr_id]
      ,P.[emp_number]
	  ,L.[PickerId]
	FROM 
	[PH_PROD].[dbxx].[usrs] AS P
		LEFT JOIN 
	[LPPick].[dbo].[Pickers] AS L
	ON P.[emp_number] = L.[PickerBarCode]
	
 