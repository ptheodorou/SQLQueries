SELECT  DATENAME(week,[Date]) AS [Week of Year]
      ,[CSR User]
	  ,COUNT([Order ID]) AS [Reships Created]
FROM [Metrics Reports].[dbo].[reships] AS A
				INNER JOIN
		[Metrics Reports].[dbo].[CSR departments] AS C
				ON A.[CSR User] = C.[UserID]
WHERE A.[Date] >= '08/01/14'
AND [Department] = 'Returns'
GROUP BY DATENAME(week,[Date])
      ,[CSR User]
ORDER BY [CSR User],[Week of Year]
