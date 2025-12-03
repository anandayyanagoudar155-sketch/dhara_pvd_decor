USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  Trigger [dbo].[Trigg_purchaseinvoice_details]    Script Date: 03-12-2025 16:56:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE trigger [dbo].[Trigg_purchaseinvoice_details]
on [dbo].[purchaseinvoice_details]
after insert,update,delete
as
BEGIN
		Update pd
		set pd.purchase = ISNULL((
				Select  sum(pid.totalquantity)
				FROM purchaseinvoice_details pid
				where pid.product_id = pd.product_id
				and pid.fin_year_id = pd.fin_year_id
				and pid.comp_id = pd.comp_id
				),0)
		from product_details pd 
		where pd.product_id = (
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
END
GO

ALTER TABLE [dbo].[purchaseinvoice_details] ENABLE TRIGGER [Trigg_purchaseinvoice_details]
GO

