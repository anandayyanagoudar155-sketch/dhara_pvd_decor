USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[ErrorLog_Ins]    Script Date: 29-10-2025 10:34:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[ErrorLog_Ins](
@ErrorNumber int = 0,
@ErrorProcedure nvarchar(128) = '',
@ErrorLine int = 0,
@Error_Message nvarchar(max) =''
)
as
Begin
Insert into ErrorLog(ErrorNumber,ErrorProcedure,ErrorLine,[Error_Message])
values(@ErrorNumber,@ErrorProcedure,@ErrorLine,@Error_Message);
End
GO

