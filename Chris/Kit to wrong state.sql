/****** Script for SelectTopNRows command from SSMS  ******/

SELECT
		[order_id]
FROM
		(SELECT 
			a.[order_id]
			,b.[item_id]
			,a.[s_state]
		FROM [PH_PROD].[dbxx].[orders] as a
			LEFT JOIN
		[PH_PROD].[dbxx].[order_lines] as b
			on a.order_id = b.order_id
		WHERE b.[item_id] in ('KT1022', 'KT1022SP', 'KT1022PR', 'KT1023', 'KT1023SP', 'KT1023PR'))AS [Kits]

WHERE ([Kits].[item_id] in ('KT1022PR', 'KT1023PR') AND [Kits].[s_state] <> 'PR') 
OR ([Kits].[item_id] in ( 'KT1022SP' , 'KT1023SP') AND [Kits].[s_state] = 'PR') 
OR ([Kits].[item_id] in ( 'KT1022', 'KT1023') AND [Kits].[s_state] = 'PR')
