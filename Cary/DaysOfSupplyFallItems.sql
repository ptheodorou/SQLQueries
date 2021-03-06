/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	A.item_id
	,A.[Average Daily Sales]
	,B.[On Hand]
	,((B.[On Hand]-A.[Average Daily Sales])/A.[Average Daily Sales]) AS [Days of Supply]
FROM
(SELECT  
      [item_id]
      ,ROUND(AVG([Total Sales]),0) AS [Average Daily Sales]
  FROM [Weeks of Supply].[dbo].[View_FallSales]
  WHERE [Date] <= '08/25/14'
  GROUP BY [item_id]) AS A
  INNER JOIN
  (SELECT [item_id]
      ,[On Hand]
  FROM [Weeks of Supply].[dbo].[View_FallSkuInventoryOnHand]) AS B
  On A.item_id = B.item_id
  ORDER BY [Days of Supply]