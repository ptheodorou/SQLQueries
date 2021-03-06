
WITH [Picks] AS (SELECT  
      [activity_date]
      ,[location_id_from]
      ,[pieces]
	  ,CASE WHEN SUBSTRING(location_id_from,3,2) in ('AA','AB','AC','BA','BB','BC')
              THEN 1
              WHEN  SUBSTRING(location_id_from,3,2) in ('AD','AE','AF','BD','BE','BF')
              THEN 2
              WHEN SUBSTRING(location_id_from,3,2) in ('AG','AH','AI','BG','BH','BI')
              THEN 3
              WHEN SUBSTRING(location_id_from,3,2) in ('AJ','AK','AL','BJ','BK','BL')
              THEN 4
              END AS [Zone]
  FROM [PH_PROD].[dbxx].[if_transaction]
  WHERE CAST(activity_date AS DATE) between '07/14/14' AND '07/18/14'
  AND if_tran_code = 'POP-PICK')

  SELECT
		[activity_date]
		,SUBSTRING(location_id_from,1,1) AS [Lane] 
		,[Zone]
		,SUM(pieces) AS [Total Picks]
FROM [Picks]
WHERE SUBSTRING(location_id_from,1,2) in ('A-','B-','C-','D-','E-','F-','G-','H-')
GROUP BY [activity_date]
        ,SUBSTRING(location_id_from,1,1)
		,[Zone]