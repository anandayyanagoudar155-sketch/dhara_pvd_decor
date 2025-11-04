USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[errorlog_ins]    Script Date: 04-11-2025 10:56:40 ******/
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

