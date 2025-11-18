USE [DharaPvdDecor_db]
GO

/****** Object:  Trigger [dbo].[Trigg_salesinvoicedetails]    Script Date: 18-11-2025 22:25:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE trigger [dbo].[Trigg_salesinvoicedetails]
on [dbo].[salesinvoicedetails]
after INSERT, UPDATE, DELETE
As
Begin
	Update pm
	set pm.sales = ISNULL((
			Select SUM(sids.totalquantity)
			from salesinvoicedetails sids 
			where sids.product_id = pm.product_id
		),0)
	from product_mast pm
	where pm.product_id = (
	Select product_id from inserted
	union
	Select product_id from deleted
	)

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

