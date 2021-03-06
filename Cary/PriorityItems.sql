WITH Backstock AS (SELECT
item_id 
,SUM(pieces_onhand) AS [Total Pieces]
FROM PH_PROD.dbxx.item_location
WHERE location_type = 'PTL-RESTK'
GROUP BY item_id 
HAVING SUM(pieces_onhand) < 500)

SELECT 
	A.*
	,ISNULL(B.[Total On Hand],0) AS [Amount in Prep/QC]
	,C.[Total On Hand] AS [Total in Receiving]
FROM
(SELECT 
	item_id
	,SUM(pieces_onhand)-(SUM(pieces_onhold) + SUM(pieces_pend)) AS [Total Available]
FROM PH_PROD.dbxx.item_location
WHERE item_id in 
(SELECT item_id
FROM [Metrics Reports].[dbo].[FallSkus])
and location_type = 'PTL'
AND item_id in (SELECT item_id FROM Backstock)
GROUP BY item_id) AS A
LEFT JOIN
(SELECT
	item_id
	,ISNULL(SUM(pieces_onhand),0) AS [Total On Hand]
FROM PH_PROD.dbxx.item_location
WHERE location_id in ('QC','PREP')
GROUP BY item_id) AS B
	ON A.[item_id] = B.item_id
LEFT JOIN
(SELECT
	item_id
	,SUM(pieces_onhand) AS [Total On Hand]
FROM PH_PROD.dbxx.item_location
WHERE location_id not in ('QC','PREP')
AND location_type not in ('PTL','PTL_RESTK')
GROUP BY item_id) AS C
	ON A.item_id = C.[item_id]
