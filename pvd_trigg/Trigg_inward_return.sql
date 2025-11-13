USE [DharaPvdDecor_db]
GO

/****** Object:  Trigger [dbo].[Trigg_inward_return]    Script Date: 13-11-2025 11:13:52 ******/
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
    UPDATE pm
    SET pm.[return] = ISNULL((
            SELECT SUM(ir.returnquantity)
            FROM inward_return ir
            WHERE ir.product_id = pm.product_id
        ), 0)
    FROM product_mast pm
    WHERE pm.product_id IN (
        SELECT product_id FROM inserted
        UNION
        SELECT product_id FROM deleted
    );
END;
GO

ALTER TABLE [dbo].[inward_return] ENABLE TRIGGER [Trigg_inward_return]
GO

