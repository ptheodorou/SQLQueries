/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
    DATEPART(week, date_ordered) AS [Week],
    [Reason],
    COUNT([Original Order ID]) AS [Orders]
FROM
(SELECT 
	  date_ordered
	  ,CASE WHEN [Reship Reason] in ('Refund','Refund Shipping')
	   Then 'Refunds'
	   WHEN [Reship Reason] in ('Missing Product','Wrong Item Received') 
	   THEN 'Mispicks'
	   WHEN [Reship Reason] = 'Defective'
	   THEN 'Defective'
	   ELSE 'Other'
	   END AS [Reason]
       ,[Original Order ID] 

  FROM [Metrics Reports].[dbo].[reships] AS A
		  INNER JOIN
	   PH_PROD.dbxx.hi_orders AS B
		  ON A.[Original Order ID] = B.order_id
WHERE CAST(date_ordered AS DATE) BETWEEN '11/01/14' AND '02/21/15')AS A
GROUP BY DATEPART(week, date_ordered),
    [Reason]
