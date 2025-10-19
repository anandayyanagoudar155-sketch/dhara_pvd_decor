----Error Log
---Error Log Table

create table [dbo].[ErrorLog](
	ErrorLogId int identity(1,1) not null primary key,
	ErrorNumber int null,
	ErrorProcedure nvarchar(128)  null,
	ErrorLine int  null,
	[Error_Message] nvarchar(max)  null 
)

----ErrorLog Procedure

create procedure ErrorLog_Ins(
@ErrorNumber int = 0,
@ErrorProcedure nvarchar(128) = '',
@ErrorLine int = 0,
@Error_Message nvarchar(max) =''
)
as
Begin
Insert into ErrorLog(ErrorNumber,ErrorProcedure,ErrorLine,[Error_Message])
values(@ErrorNumber,@ErrorProcedure,@ErrorLine,@ErrorProcedure);
End