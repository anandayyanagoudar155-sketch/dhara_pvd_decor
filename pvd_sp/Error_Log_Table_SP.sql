CREATE TABLE [dbo].[errorlog](
	[errorlogid] [int] IDENTITY(1,1) NOT NULL,
	[errornumber] [int] NULL,
	[errorprocedure] [nvarchar](128) NULL,
	[errorline] [int] NULL,
	[errormessage] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[errorlogid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
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
