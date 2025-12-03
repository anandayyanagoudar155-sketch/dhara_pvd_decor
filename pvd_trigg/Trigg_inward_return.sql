USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  Trigger [dbo].[Trigg_inward_return]    Script Date: 03-12-2025 16:55:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE TRIGGER [dbo].[Trigg_inward_return]
ON [dbo].[inward_return]
AFTER INSERT, UPDATE, DELETE  
AS
BEGIN
    SET NOCOUNT ON;

    -- Update inward_mast balance_quantity when rows are inserted or updated
    UPDATE im
    SET im.balance_quantity = im.totalquantity 
                              - ISNULL((
                                  SELECT SUM(ir.returnquantity)
                                  FROM inward_return ir
                                  WHERE ir.inward_id = im.inward_id
                              ), 0)
    FROM inward_mast im
    WHERE im.inward_id IN (
        SELECT inward_id FROM inserted
        UNION
        SELECT inward_id FROM deleted
    );

    -- Update product_mast (assuming you meant to update a quantity field, e.g., returnquantity)
    UPDATE pd
    SET pd.[return] = ISNULL((
            SELECT SUM(ir.returnquantity)
            FROM inward_return ir
            WHERE ir.product_id = pd.product_id
			and ir.fin_year_id = pd.fin_year_id
			and ir.comp_id = pd.comp_id
        ), 0)
    FROM product_details pd
    WHERE pd.product_id IN (
        SELECT product_id FROM inserted
        UNION
        SELECT product_id FROM deleted
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
END;
GO

ALTER TABLE [dbo].[inward_return] ENABLE TRIGGER [Trigg_inward_return]
GO

