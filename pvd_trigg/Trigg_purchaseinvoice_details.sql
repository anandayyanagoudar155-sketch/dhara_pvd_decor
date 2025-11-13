USE [DharaPvdDecor_db]
GO

/****** Object:  Trigger [dbo].[Trigg_purchaseinvoice_details]    Script Date: 13-11-2025 17:11:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER trigger [dbo].[Trigg_purchaseinvoice_details]
on [dbo].[purchaseinvoice_details]
after insert,update,delete
as
BEGIN
		Update pm
		set pm.purchase = ISNULL((
				Select  sum(pid.totalquantity)
				FROM purchaseinvoice_details pid
				where pid.product_id = pm.product_id
				),0)
		from product_mast pm 
		where pm.product_id = (
		Select product_id from inserted
		union
		Select product_id from deleted
		)
END
GO

