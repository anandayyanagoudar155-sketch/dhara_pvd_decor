USE [DharaPvdDecor_db]
GO

/****** Object:  Trigger [dbo].[trigg_dailyconsumption_mast]    Script Date: 13-11-2025 17:08:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create trigger [dbo].[trigg_dailyconsumption_mast]
on [dbo].[dailyconsumption_mast]
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
update pm
set pm.sales = ISNULL((
			Select SUM(dcm.quantityconsumed)
			from dailyconsumption_mast dcm
			where dcm.product_id = pm.product_id
			),0)
from product_mast pm
where product_id = (
Select product_id from inserted
union
Select product_id from deleted
) 
END;
GO

ALTER TABLE [dbo].[dailyconsumption_mast] ENABLE TRIGGER [trigg_dailyconsumption_mast]
GO

