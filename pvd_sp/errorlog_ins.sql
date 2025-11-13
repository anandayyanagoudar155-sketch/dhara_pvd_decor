USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[errorlog_ins]    Script Date: 13-11-2025 10:46:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[errorlog_ins](
@error_number int = 0,
@error_procedure nvarchar(128) = '',
@error_line int = 0,
@error_message nvarchar(max) =''
)
as
Begin
Insert into ErrorLog(errornumber,errorprocedure,errorline,[errormessage])
values(@error_number,@error_procedure,@error_line,@error_message);
End
GO

