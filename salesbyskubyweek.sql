---*** Sales By Sku***
	SELECT
		Z.[PartNumber]
		,Z.[ProductName]
		,SUM(Z.[Quantity]) AS [Total Ordered]
	FROM [DataWarehouseSupport].[dbo].[ZoytoOrderLines] AS Z
			LEFT JOIN
		[PH_PROD].[dbxx].[hi_orders] AS P
		ON Z.[OrderID]= P.[po_num]
	WHERE [OrderID] NOT LIKE 'R%'
		AND CAST(P.[date_ordered] AS DATE) between '11/03/13' and '11/09/13'
	GROUP BY 
		Z.[PartNumber],
		Z.[ProductName]
	ORDER BY 
		[Total Ordered] DESC
	