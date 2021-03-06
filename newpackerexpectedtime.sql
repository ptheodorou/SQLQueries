SELECT
	[usr_id]
	,MAX([Time])
FROM
(SELECT  
	  [usr_id]
      ,DATEDIFF(second, lag(login_time) OVER (PARTITION BY [usr_id] ORDER BY [login_time]),[logout_time])/60.0/60.0 AS [Time]
  FROM [PH_PROD].[dbxx].[hi_usr_login]
  WHERE [host_name] like 'O2-PACK%'
  AND CAST(login_time AS DATE) = '05/29/14')AS A
  GROUP BY [usr_id]
