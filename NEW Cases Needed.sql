/****** Script for SelectTopNRows command from SSMS  ******/

SELECT
		C.lane_type,
		C.location_id,
		C.item_id,
		(C.ordered * -1) as Pieces_needed,
	r.pieces_per_case,
	ceiling((C.ordered * -1)/r.pieces_per_case) as cases_needed
FROM
(SELECT
		a.lane_type,
		a.location_id,
		a.item_id,
		(a.[Order Available] - b.pieces_ordered) as ordered

FROM	



(SELECT 
      (CASE left(location_id,1)
						WHEN 'A' THEN 'RETAIL' 
						WHEN 'B' THEN 'RETAIL'
						WHEN 'C' THEN 'PARTY'
						WHEN 'D' THEN 'PARTY'
						WHEN 'E' THEN 'WHOLESALE'
						WHEN 'F' THEN 'PARTY'
						WHEN 'G' THEN 'WHOLESALE'
						WHEN 'H' THEN 'PARTY'
						end) as lane_type,
						location_id,
      (pieces_OnHand - ( Pieces_OnHold + Pieces_Block)) as 'Order Available',
      [item_id]
      
    
  FROM [PH_PROD].[dbxx].[item_location]
  WHERE location_type = 'PTL') as a

  LEFT JOIN


  (SELECT      
		    a.[item_id]
			  ,b.order_type
      
		    ,sum(a.[pieces_ordered]) as pieces_ordered
		 FROM [PH_PROD].[dbxx].[order_lines] as a
				LEFT JOIN
				[PH_PROD].[dbxx].[orders] as B
				on a.order_id = b.order_id
		where b.order_status = 010
			GROUP BY a.item_id, b.ORDER_TYPE) as b
	

			on a.lane_type = b.order_type and a.item_id = b.item_id
			
	WHERE pieces_ordered is not null ) as C

	LEFT JOIN
	[PH_PROD].[dbxx].[item_configuration] as R
		on C.item_id = r.item_id

	WHERE r.standard_cfg = 'Y' and c.ordered < 0
