USE [DharaPvdDecor_db]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_split_ints]    Script Date: 12/16/2025 1:18:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_split_ints]
(
    @list NVARCHAR(MAX)
)
RETURNS @result TABLE (value INT)
AS
BEGIN
    DECLARE @start INT = 1,
            @end   INT,
            @item  NVARCHAR(20);

    SET @list = LTRIM(RTRIM(@list));

    -- Add comma at end
    SET @list = @list + ',';

    WHILE CHARINDEX(',', @list, @start) > 0
    BEGIN
        SET @end = CHARINDEX(',', @list, @start);

        SET @item = SUBSTRING(@list, @start, @end - @start);

        IF ISNUMERIC(@item) = 1
            INSERT INTO @result(value)
            VALUES (CAST(@item AS INT));

        SET @start = @end + 1;
    END

    RETURN;
END;

GO

