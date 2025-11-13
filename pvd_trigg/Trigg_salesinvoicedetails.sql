USE [DharaPvdDecor_db]
GO

/****** Object:  Trigger [dbo].[Trigg_salesinvoicedetails]    Script Date: 13-11-2025 17:12:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create trigger [dbo].[Trigg_salesinvoicedetails]
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
End
GO

ALTER TABLE [dbo].[salesinvoicedetails] ENABLE TRIGGER [Trigg_salesinvoicedetails]
GO

