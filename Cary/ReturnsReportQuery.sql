/*Returns based on RMA's*/
WITH [Returns] AS(SELECT 
	   DATEPART(week,date_shipped) AS [WeekofYear]
	   ,MIN(cast(date_shipped AS DATE)) AS [Start Date]
	   ,SUM([ReturnQuantity]) AS [Units Returned]
  FROM [Metrics Reports].[dbo].[RMAReportingData] AS A
		  INNER JOIN
	   PH_PROD.dbxx.hi_orders AS B
		  ON A.PowerhouseOrderID = B.order_id
  WHERE PrimaryReason in ('Missing Item','Wrong item')
  GROUP BY DATEPART(week,date_shipped))
/*Total Number of Picks made*/
, Picks AS
(SELECT
	DATEPART(week,[activity_date]) AS [WeekofYear]
      ,SUM([pieces]) AS [Units Picked]
  FROM [DataWarehouse].[dbo].[PickedItemsbyPicker]
  WHERE CAST(activity_date AS DATE) >= '06/01/14'
  GROUP BY DATEPART(week,[activity_date])),
/*Errors found at inspection*/
  Exceptions AS
  (SELECT
		DATEPART(week,[activity_date]) AS [WeekofYear]
		,COUNT(exception_type) AS [Total Units Found]
FROM PH_PROD.dbxx.exceptions2
WHERE exception_type in ('MISSING','WRONG ITEM')
GROUP BY DATEPART(week,[activity_date])),
/*Total Number of Units Inspected*/
Inspection AS 
(SELECT
	DATEPART(week,[activity_date]) AS [WeekofYear]
	,SUM(pieces) AS [Units]
FROM PH_PROD.dbxx.if_transaction
WHERE order_id in (
SELECT	
	order_id 
FROM PH_PROD.dbxx.if_transaction
WHERE if_tran_code = 'VERIFY')
AND if_tran_code = 'POP-PICK'
GROUP BY DATEPART(week,[activity_date]))
/* Returned Units to be Expected Based on Received RMAs and Inspection*/
SELECT
	A.[Start Date]
	,A.WeekofYear
	,B.[Units Picked] AS [Picks]
	,A.[Units Returned] AS [Returns Made in Units]
	,C.[Total Units Found] AS [Mispicks Found at Inspection]
	,D.Units AS [Inspected Units]
	,(B.[Units Picked]-D.Units)*(CAST(C.[Total Units Found] AS DECIMAL)/CAST(D.Units AS  DECIMAL)) AS [Expected Units to be Returned]
FROM	[Returns] AS A
		INNER JOIN
		[Picks] AS B
		ON A.WeekofYear= B.WeekofYear
		INNER JOIN
		[Exceptions] AS C
		ON A.WeekofYear = C.WeekofYear
		INNER JOIN
		[Inspection] AS D
		ON A.WeekofYear = D.WeekofYear
	

	 