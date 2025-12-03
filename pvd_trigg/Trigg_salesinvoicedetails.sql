USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  Trigger [dbo].[Trigg_salesinvoicedetails]    Script Date: 03-12-2025 16:57:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE trigger [dbo].[Trigg_salesinvoicedetails]
on [dbo].[salesinvoicedetails]
after INSERT, UPDATE, DELETE
As
Begin
	Update pd
	set pd.sales = ISNULL((
			Select SUM(sids.totalquantity)
			from salesinvoicedetails sids 
			where sids.product_id = pd.product_id
			and sids.fin_year_id = pd.fin_year_id
			and sids.comp_id = pd.comp_id
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
	);

	Update im
	set im.balance_Quantity = im.totalquantity - (ISNULL((
															Select SUM(ir.returnquantity)
															from inward_return ir 
															where ir.inward_id = im.inward_id
														),0) + 
														ISNULL((
															Select SUM(sids.totalquantity)
															from salesinvoicedetails sids 
															where sids.inward_id = im.inward_id
														),0))
	from inward_mast im
	where im.inward_id = (
	Select inward_id from inserted
	union
	Select inward_id from deleted
	)
End
GO

ALTER TABLE [dbo].[salesinvoicedetails] ENABLE TRIGGER [Trigg_salesinvoicedetails]
GO

