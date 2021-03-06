/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	a.type,
	count(a.type) as Total
	FROM
(SELECT Distinct 
	[package_trace_id],
	case WHEN len([package_trace_id]) = 12 then 'EXPRESS' else 'GROUND' END as TYPE


  FROM [PH_PROD].[dbxx].[hi_work_cartons]
  WHERE cast(shipsys_tran_id as date) = '06/13/2014' and carrier_id = 'FDX') as a
  GROUP BY type