DECLARE @StartDate DATE, @EndDate DATE;
SET @StartDate = '12/01/14'
SET @EndDate = '12/03/14';

SELECT
    Start.[Date] AS [StartDate],
    [End].[Date] AS [EndDate],
    Start.item_id,
    SUM(Start.pieces_onhand) AS [Starting On Hand],
    SUM(ISNULL(Adj.[Count of Adjustments],0)) AS [Total Adjustments Made],
    SUM(ISNULL(Adj.Pieces,0)) AS [Total Pieces Adjusted],
    SUM(ISNULL([Total Sales],0)) AS [Total Sales],
    SUM(Start.pieces_onhand) + SUM(ISNULL(Adj.Pieces,0))-SUM(ISNULL([Total Sales],0)) AS [Expected On Hand],
    SUM(ISNULL([End].[pieces_onhand],0)) AS [Ending On Hand],
    (SUM(ISNULL([End].[pieces_onhand],0))-(SUM(Start.pieces_onhand) + SUM(ISNULL(Adj.Pieces,0))-SUM(ISNULL([Total Sales],0)))) AS Variance,
    (SUM(ISNULL([End].[pieces_onhand],0))-(SUM(Start.pieces_onhand) + SUM(ISNULL(Adj.Pieces,0))-SUM(ISNULL([Total Sales],0))))*SUM(Cost.StdUnitCost) AS [CostofVariance]
FROM
(SELECT
    [Date]
    ,item_id
    ,pieces_onhand
FROM
(SELECT [Date]
      ,[item_id] 
      ,SUM([pieces_onhand]) AS [pieces_onhand]
  FROM [InventoryVariances].[dbo].[ItemLocations]
  GROUP BY [Date], item_id

UNION ALL

SELECT
    [Date]
    ,item_id
    ,pieces_onhand
FROM [Metrics Reports].dbo.InventoryOnHandOldData
WHERE [Date] <= '05/19/14'
UNION ALL

SELECT  
    [Date],
    item_id,
    SUM([Pieces On Hand]) AS pieces_onhand
    FROM [Metrics Reports].dbo.InventoryOnHand
    WHERE [Date] >= '08/15/14'
    GROUP BY [Date],
    item_id)AS A
WHERE CAST([Date] AS DATE) = @StartDate) AS Start
LEFT JOIN
(SELECT  [activity_date]
      ,[item_id]
      ,[item_class]
      ,[if_tran_code]
      ,[screen_id]
      ,[Count of Adjustments]
      ,[Category]
      ,[Pieces]
  FROM [Metrics Reports].[dbo].[view_adjustmentsdetail]
  WHERE CAST([activity_date] AS DATE) between @StartDate and DATEADD(day,-1,@EndDate)) AS Adj
ON Start.item_id = Adj.item_id
LEFT JOIN
(SELECT
    [Date]
    ,item_id
    ,pieces_onhand
FROM
(SELECT [Date]
      ,[item_id] 
      ,SUM([pieces_onhand]) AS [pieces_onhand]
  FROM [InventoryVariances].[dbo].[ItemLocations]
  GROUP BY [Date], item_id

UNION ALL

SELECT
    [Date]
    ,item_id
    ,pieces_onhand
FROM [Metrics Reports].dbo.InventoryOnHandOldData
WHERE [Date] <= '05/19/14'

UNION ALL

SELECT  
    [Date],
    item_id,
    SUM([Pieces On Hand]) AS pieces_onhand
    FROM [Metrics Reports].dbo.InventoryOnHand
    WHERE [Date] >= '08/15/14'
    GROUP BY [Date],
    item_id)AS A
WHERE CAST([Date] AS DATE) = @EndDate) AS [End]
On [Start].item_id = [End].item_id
LEFT JOIN
(SELECT	  
    item_id,
    SUM(pieces) AS [Total Sales]
FROM PH_PROD.dbxx.if_transaction
WHERE CAST([activity_date] AS DATE) between @StartDate and DATEADD(day,-1,@EndDate)
AND if_tran_code = 'POP-PICK'
GROUP BY item_id) AS [Sales]
ON [Start].item_id = Sales.item_id
INNER JOIN
(SELECT 
    ItemID,
    StdUnitCost
FROM mas500_app.dbo.timItem)AS [Cost]
ON Start.item_id = Cost.ItemID
GROUP BY Start.[Date],[End].[Date],Start.item_id