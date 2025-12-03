USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  Trigger [dbo].[trigg_dailyconsumption_mast]    Script Date: 03-12-2025 16:53:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create trigger [dbo].[trigg_dailyconsumption_mast]
on [dbo].[dailyconsumption_mast]
AFTER INSERT,UPDATE,DELETE
AS
BEGIN
update pd
set pd.sales = ISNULL((
			Select SUM(dcm.quantityconsumed)
			from dailyconsumption_mast dcm
			where dcm.product_id = pd.product_id
			and dcm.fin_year_id = pd.fin_year_id
			and dcm.comp_id = pd.comp_id				
			),0)
		from product_details pd
		where product_id = (
		Select product_id from inserted
		union
		Select product_id from deleted
		) and
		pd.fin_year_id = (
		Select fin_year_id from inserted
		union
		Select fin_year_id from deleted
		) and
		pd.comp_id = (
		Select comp_id from inserted
		union
		Select comp_id from deleted
		) 
END;
GO

ALTER TABLE [dbo].[dailyconsumption_mast] ENABLE TRIGGER [trigg_dailyconsumption_mast]
GO

