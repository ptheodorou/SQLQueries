SELECT
              A.[CSR User]
              ,B.[CSR User]
              ,C.[Original Order ID]
              ,A.[Order ID]
              ,B.[Order ID]
              ,C.[date_ordered]
              ,A.[date_ordered]
              ,B.[date_ordered]
              ,C.[date_shipped]
              ,A.[date_shipped]
              ,B.[date_shipped]
              ,C.[item_id]
              ,A.item_id
              ,B.[item_id]
              ,A.[Reship Reason]
              ,B.[Reship Reason]
              ,A.[Department]
              ,B.[Department]
FROM 
    (SELECT 
       [CSR User]
       ,B.[Department]
       ,[Reship Reason]
          ,[Original Order ID]
                ,[Order ID]
                ,[date_ordered]
                ,date_shipped
                ,D.item_id
FROM [Metrics Reports].[dbo].[reships]AS A
                     INNER JOIN 
       [Metrics Reports].[dbo].[CSR departments] AS B
                     ON A.[CSR User] = B.[UserID]
                                  INNER JOIN
              [PH_PROD].[dbxx].[hi_orders] AS C
                                  ON A.[Order ID] = C.[po_num]
                                  INNER JOIN
              [PH_PROD].[dbxx].[hi_order_lines] AS D
                                  ON C.[order_id] = D.[order_id] 
              WHERE [Date] between '01/01/14' and '07/31/14') AS A
                                  INNER JOIN
    (SELECT 
       [CSR User]
       ,B.[Department]
       ,[Reship Reason]
          ,[Original Order ID]
                ,[Order ID]
                ,[date_ordered]
                ,date_shipped
                ,D.item_id
FROM [Metrics Reports].[dbo].[reships]AS A
                     INNER JOIN 
       [Metrics Reports].[dbo].[CSR departments] AS B
                     ON A.[CSR User] = B.[UserID]
                                  INNER JOIN
              [PH_PROD].[dbxx].[hi_orders] AS C
                                  ON A.[Order ID] = C.[po_num]
                                  INNER JOIN
              [PH_PROD].[dbxx].[hi_order_lines] AS D
                                  ON C.[order_id] = D.[order_id] 
                                  WHERE [Date] between '01/01/14' and '07/31/14') AS B
                                         ON A.[Original Order ID] = B.[Original Order ID] AND A.[Order ID] != B.[Order ID] AND A.[item_id] = B.[item_id] AND A.[CSR User] != B.[CSR User] 
                                         INNER JOIN
(SELECT 

          [Original Order ID]
                ,[date_ordered]
                ,date_shipped
                ,D.item_id
FROM [Metrics Reports].[dbo].[reships]AS A
                     INNER JOIN 
       [Metrics Reports].[dbo].[CSR departments] AS B
                     ON A.[CSR User] = B.[UserID]
                                  INNER JOIN
              [PH_PROD].[dbxx].[hi_orders] AS C
                                  ON A.[Original Order ID] = C.[order_id]
                                  INNER JOIN
              [PH_PROD].[dbxx].[hi_order_lines] AS D
                                  ON C.[order_id] = D.[order_id] 
                                  WHERE [Date] between '01/01/14' and '07/31/14') AS C
                                         ON A.[Original Order ID] = C.[Original Order ID] AND A.[item_id] = C.[item_id]
