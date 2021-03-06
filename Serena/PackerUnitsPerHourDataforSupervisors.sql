/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	CAST(A.activity_date AS DATE) AS [Date]
	,B.[full_name]
	,A.[Hours]
	,A.[Total Units]/A.[Hours] AS [Units Per Hour] 
FROM
(SELECT  [usr_id]
      ,[activity_date]
      ,SUM(CONVERT(INT,[Tot_Orders])) AS [Total Orders]
      ,SUM(CONVERT(INT,[Tot_units])) AS [Total Units]
      ,SUM(CONVERT(DECIMAL,[Tot_time_in_Seconds]))/60/60 AS [Hours]
  FROM [PH_PROD].[dbo].[vw_PackerProductivity]
  GROUP BY [usr_id]
      ,[activity_date]) AS A
		INNER JOIN
   [PH_PROD].[dbxx].[usrs] AS B
		ON A.[usr_id] = B.[usr_id] 
WHERE CAST(A.activity_date AS DATE) between '01/01/14' and '01/31/14'
ORDER BY B.[full_name], [Date]
