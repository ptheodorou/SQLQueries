

SELECT 
	[Non Inspected].[Date]
	,U.[full_name]
	,[Non Inspected].[station]
	,(ISNULL(Inspected.[Hours],0)+ISNULL([Non Inspected].[Hours],0)) AS [Total Hours]
	---,ISNULL(Inspected.[Hours],0) AS [Inspected Hours]
	---,ISNULL([Non Inspected].[Hours],0) AS [Non Inspected Hours]
	,(ISNULL([Inspected].[Orders],0) + ISNULL([Non Inspected].[Orders],0)) AS [Total Orders]
	,ISNULL([Inspected].[Orders],0) AS [Inspected Orders]
	,ISNULL([Non Inspected].[Orders],0) AS [Non Inspected Orders]
	,(ISNULL(Inspected.units,0)+ISNULL([Non Inspected].units,0)) AS [Total Units]
	---,ISNULL(Inspected.units,0) AS [Inspected Units]
	---,ISNULL([Non Inspected].units,0) AS [Non Inspected Units]
	,((ISNULL(Inspected.units,0)+ISNULL([Non Inspected].units,0))/(ISNULL(Inspected.[Hours],0)+ISNULL([Non Inspected].[Hours],0))) AS [Units Per Hour]
	---,(ISNULL(Inspected.units,0)/ISNULL(Inspected.[Hours],0)) AS [Inspected UPH]
	---,(ISNULL([Non Inspected].units,0)/ISNULL([Non Inspected].[Hours],0)) AS [Non Inspected UPH]
	---,((ISNULL([Inspected].[Orders],0) + ISNULL([Non Inspected].[Orders],0))/(ISNULL(Inspected.[Hours],0)+ISNULL([Non Inspected].[Hours],0))) AS [Orders Per Hour]
	---,ISNULL([Inspected].[Orders],0)/ISNULL(Inspected.[Hours],0) AS [Inspected OPH]
	--,ISNULL([Non Inspected].[Orders],0)/ISNULL([Non Inspected].[Hours],0) AS [Non Inspected OPH]
FROM
(SELECT
		CAST(activity_date AS DATE) AS [Date]
       ,[usr_id]
      ,[Station]
      ,SUM(CONVERT(INT,[Total Orders])) AS [Orders]
      ,SUM(CONVERT(INT,[Total Units])) AS [Units]
      ,SUM(CONVERT(DECIMAL,[Time in Seconds]))/60.0/60.0 AS [Hours]
  FROM [PH_PROD].[dbo].[vw_Packer_Shipped]
  WHERE CAST(activity_date AS DATE) between '07/03/14' AND '07/03/14'

  AND[if_tran_code] = 'VERIFY'
  GROUP BY  CAST(activity_date AS DATE),[usr_id]
      ,[Station]) AS [Inspected]
			INNER JOIN
(SELECT  
		CAST(activity_date AS DATE) AS [Date]
		,[usr_id]
      ,[Station]
      ,SUM(CONVERT(INT,[Total Orders])) AS [Orders]
      ,SUM(CONVERT(INT,[Total Units])) AS [Units]
      ,SUM(CONVERT(DECIMAL,[Time in Seconds]))/60.0/60.0 AS [Hours]
  FROM [PH_PROD].[dbo].[vw_Packer_Shipped]
  WHERE CAST(activity_date AS DATE) between '07/03/14' and '07/03/14'
  AND[if_tran_code] = 'VERIFY-Q'
  GROUP BY  CAST(activity_date AS DATE),[usr_id]
      ,[Station]) AS [Non Inspected]
		ON [Inspected].usr_id = [Non Inspected].usr_id AND Inspected.station = [Non Inspected].station AND Inspected.[Date] = [Non Inspected].[Date]
		INNER JOIN
		[PH_PROD].dbxx.[usrs] AS U
			ON [Non Inspected].[usr_id] = U.[usr_id]

