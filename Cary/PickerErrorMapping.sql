/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
    [in].*
    ,CASE WHEN [In].[IsSameSide] = 'Y'
		  AND [In].[IsSameBay] = 'Y'
		  AND [In].[IsSameSlot] = 'Y'
		  AND [Area] = 'Same Zone'
		  and [Error Type] not in ('Up/Down','Same Location')
		  THEN 'Locations Are UP and Down but Not Close'
		  WHEN [In].[IsSameSide] = 'Y'
		  AND [In].[IsSameBay] = 'Y'
		  AND [In].[IsSameShelf] = 'Y'
		  AND [Area] = 'Same Zone'
		  AND [Error Type] not in ('Left/Right','Same Location')
		  THEN 'Locations are Same Shelf but not Close'
		  WHEN [In].[Error Type] = 'Same Location'
		  THEN 'Same Location, Picked Wrong Quantity'
		  ELSE [Error Type]
		  END AS [Secondary Reason]
    ,[out].[ProductSku]
    ,[Out].[ReturnQuantity]
    ,[Out].[PrimaryReason]
    ,[Out].[TicketCreated]
FROM
(SELECT
    Z.usr_id
    ,CAST(Z.activity_date AS DATE) AS [Date]
    ,Z.exception_type
    ,Z.item_id AS [Expected Item]
    ,Z.Item AS [Received Item]
    ,Z.[order_id]
    ,Z.[location_id_from] AS [Expected Location]
    ,Z.[location_id] AS [Actual Location Picked]
    ,Z.[Picker BarCode]
    ,D.full_name AS [Picker]
    ,Area
        ,CASE WHEN [Expected Side] = [Received Side]
		THEN 'Y'
		ELSE 'N'
		END AS [IsSameSide]
    ,CASE WHEN [Expected Bay] = [Received Bay]
		THEN 'Y'
		ELSE 'N'
		END AS [IsSameBay]
    ,CASE WHEN SUBSTRING(location_id_from,9,2) = SUBSTRING(location_id,9,2) AND Area = 'Same Zone'
		  AND [Expected Side] = [Received Side] AND [Expected Bay] = [Received Bay]
		THEN 'Y'
		ELSE 'N'
		END AS [IsSameSlot]
    ,CASE WHEN SUBSTRING(location_id_from,7,2) = SUBSTRING(location_id,7,2) AND Area = 'Same Zone'
		  AND [Expected Side] = [Received Side] AND [Expected Bay] = [Received Bay]
		THEN 'Y'
		ELSE 'N'
		END AS [IsSameShelf]
    ,CASE WHEN ABS([Number of Shelves]) = 1
		 AND SUBSTRING(location_id_from,9,2) = SUBSTRING(location_id,9,2) AND Area = 'Same Zone'
		  AND [Expected Side] = [Received Side] AND [Expected Bay] = [Received Bay]
		THEN 'Up/Down'
		WHEN ABS([Slots]) = 1
		AND SUBSTRING(location_id_from,9,2) != SUBSTRING(location_id,9,2) AND Area = 'Same Zone'
		  AND [Expected Side] = [Received Side] AND [Expected Bay] = [Received Bay]
		THEN 'Left/Right'
		WHEN location_id_from = location_id
		THEN 'Same Location'
		ELSE ' Locations not in Same Area'
		END AS [Error Type]
FROM   
(SELECT
    Y.*
    ,CASE WHEN Area = 'Same Zone'  AND [Expected Side] = [Received Side] AND [Number of Shelves] = 0
	   AND [Expected Bay] = [Received Bay]
	   THEN CAST(SUBSTRING(location_id_from,10,1) AS INT) - CAST(SUBSTRING(location_id,10,1) AS INT)
	   END AS [Slots]
FROM
(SELECT
    x.*
    ,CASE WHEN Area = 'Same Zone' and [Expected Side] = [Received Side]
		AND [Expected Bay] = [Received Bay]
	   THEN CAST(SUBSTRING(location_id_from,7,1) AS INT) - CAST(SUBSTRING(location_id,7,1) AS INT)
	   END AS [Number of Shelves]
FROM
(SELECT
    A.usr_id
    ,A.activity_date
    ,A.activity_time
    ,A.exception_type
    ,A.Item
    ,A.item_id
    ,A.Lane
    ,A.location_id_from
    ,A.order_id
    ,A.[Picker BarCode]
    ,A.requester
    ,B.location_id
    ,a.Zone AS [Expected Zone]
    ,B.Zone2 AS [Received Zone]
    ,A.Side AS [Expected Side]
    ,B.Side1 AS [Received Side]
    ,A.Bay AS [Expected Bay]
    ,B.Bay1 AS [Received Bay]
    ,CASE WHEN A.Zone = B.Zone2
	   THEN 'Same Zone'
	   ELSE 'Different Zone'
	   END AS Area
FROM
(SELECT 
       A.[usr_id]
      ,A.[activity_date]
      ,A.[activity_time]
      ,[exception_type]
      ,RIGHT(RTRIM([exception_text]),6) AS [Item]
      ,[location_id]
      ,A.[item_id]
      ,A.[order_id]
	 ,B.usr_id AS [Picker BarCode]
	 ,B.requester
	 ,B.location_id_from
	 ,SUBSTRING(location_id_from,1,1) AS [Lane]
	 ,CASE WHEN SUBSTRING(location_id_from,4,1) in ('A','B','C')
		  THEN 1
		  WHEN  SUBSTRING(location_id_from,4,1) in ('D','E','F')
		  THEN 2
		  WHEN SUBSTRING(location_id_from,4,1) in ('G','H','I')
		  THEN 3
		  ELSE 4
		  END AS Zone
      ,CASE WHEN SUBSTRING(location_id_from,3,1) = 'A'
		  THEN 1
		  ELSE 2
		  END AS [Side]
      ,SUBSTRING(location_id_from,4,1) AS [Bay]
  FROM [PH_PROD].[dbxx].[exceptions2] AS A
		  LEFT JOIN
       PH_PROD.dbxx.if_transaction AS B
		  ON A.order_id = B.order_id
		  AND A.item_id = B.item_id
  WHERE exception_type  in ('MISSING','WRONG ITEM','EXTRA ITEM')
  and if_tran_code = 'POP-PICK'
  and A.usr_id in ('cfleming','ggladden','csibounhom','mromo','turiarte','lcruz','csprague','amoore','bclark','dhalsell')
  and CAST(A.activity_date AS DATE) ='11/10/14')AS A
	   LEFT JOIN
    (SELECT
		 item_id
		 ,location_id
		 ,CASE WHEN SUBSTRING(location_id,4,1) in ('A','B','C')
		  THEN 1
		  WHEN  SUBSTRING(location_id,4,1) in ('D','E','F')
		  THEN 2
		  WHEN SUBSTRING(location_id,4,1) in ('G','H','I')
		  THEN 3
		  ELSE 4
		  END AS Zone2
		  ,CASE WHEN SUBSTRING(location_id,3,1) = 'A'
		  THEN 1
		  ELSE 2
		  END AS Side1
		  ,SUBSTRING(location_id,4,1) AS Bay1
    FROM PH_PROD.dbxx.item_location
    WHERE location_type = 'PTL')AS B
	   ON A.Item = B.item_id AND A.Lane = SUBSTRING(B.location_id,1,1)
WHERE CAST(activity_date AS DATE) >= '10/16/14') AS X) AS Y)AS Z
LEFT JOIN
   PH_PROD.dbxx.usrs AS D
   ON Z.[Picker BarCode] = D.emp_number) AS [In]
   LEFT JOIN
(SELECT
    *
FROM [Metrics Reports].dbo.RMAReportingData
WHERE PrimaryReason in ('Missing Item','Wrong Item')) AS [Out]
    ON [In].order_id = [Out].PowerhouseOrderId