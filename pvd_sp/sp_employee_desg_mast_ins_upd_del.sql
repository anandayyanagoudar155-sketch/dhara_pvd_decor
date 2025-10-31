USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_employee_desg_mast_ins_upd_del]    Script Date: 31-10-2025 16:42:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_employee_desg_mast_ins_upd_del]
(
@action varchar(max) = '',
@desg_id bigint = 0,
@desg_name varchar(100) = '',
@desg_desc varchar(max) = '',
@daily_wk_hr decimal(5,2) = 0,
@created_date date = null,
@updated_date date = null,
@user_id bigint =0
)
as
BEGIN
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);
	if @action = 'insert'
	begin
		begin try
			begin transaction
			insert into employee_desg_mast(desg_name,desg_desc,daily_wk_hr,created_date,updated_date,user_id)
			values(@desg_name,@desg_desc,@daily_wk_hr,@created_date,@updated_date,@user_id);
			commit transaction;
		end try
		begin catch
			If XACT_STATE() <> 0
				rollback transaction;
			
			set @errornumber = ERROR_NUMBER();
			set @errorprocedure = ERROR_PROCEDURE();
			set @errorline = ERROR_LINE();
			set @errormessage = ERROR_MESSAGE();

			exec errorlog_ins 
				 @errornumber,
				 @errorprocedure,
				 @errorline,
				 @errormessage;
		end catch
	end
	if @action = 'select all'
	begin
		begin try
			Select desg_id,desg_name,desg_desc,daily_wk_hr,created_date,updated_date,user_id
			from employee_desg_mast;
		end try
		begin catch
			set @errornumber = ERROR_NUMBER();
			set @errorprocedure = ERROR_PROCEDURE();
			set @errorline = ERROR_LINE();
			set @errormessage = ERROR_MESSAGE();

			exec errorlog_ins 
				 @errornumber,
				 @errorprocedure,
				 @errorline,
				 @errormessage;
		end catch
	end
	if @action = 'select one'
	begin
		begin try
			Select desg_id,desg_name,desg_desc,daily_wk_hr,created_date,updated_date,user_id
			from employee_desg_mast
			where desg_id = @desg_id;
		end try
		begin catch
			set @errornumber = ERROR_NUMBER();
			set @errorprocedure = ERROR_PROCEDURE();
			set @errorline = ERROR_LINE();
			set @errormessage = ERROR_MESSAGE();

			exec errorlog_ins 
				 @errornumber,
				 @errorprocedure,
				 @errorline,
				 @errormessage;
		end catch
	end
	if @action = 'delete'
	begin
	declare @rec_count bigint;
		begin try
			begin transaction
			set @rec_count = (
								Select count(desg_id) from employee_mast where desg_id = @desg_id
							 )
			if @rec_count > 0
			begin
				rollback transaction;
				return;
			end
			delete from employee_desg_mast where desg_id = @desg_id;
			commit transaction;
		end try
		begin catch
			If XACT_STATE() <> 0
				rollback transaction;

			set @errornumber = ERROR_NUMBER();
			set @errorprocedure = ERROR_PROCEDURE();
			set @errorline = ERROR_LINE();
			set @errormessage = ERROR_MESSAGE();

			exec errorlog_ins 
				 @errornumber,
				 @errorprocedure,
				 @errorline,
				 @errormessage;
		end catch
	end
	if @action = 'update'
	begin
		begin try
			begin transaction
			update employee_desg_mast
			set desg_name = @desg_name,
				desg_desc = @desg_desc,
				daily_wk_hr = @daily_wk_hr,
				updated_date = @updated_date,
				user_id = @user_id
			where desg_id = @desg_id;

			if @@ROWCOUNT = 0
			begin
				rollback transaction;
				return;
			end
			commit transaction;
		end try
		begin catch
			if XACT_STATE() <> 0
				rollback transaction;

			set @errornumber = ERROR_NUMBER();
			set @errorprocedure = ERROR_PROCEDURE();
			set @errorline = ERROR_LINE();
			set @errormessage = ERROR_MESSAGE();

			exec errorlog_ins 
				 @errornumber,
				 @errorprocedure,
				 @errorline,
				 @errormessage;
		end catch
	end
	if @action = 'employee_desg_mastlist'
	begin
		begin try
			Select desg_id,desg_name
			from employee_desg_mast;
		end try
		begin catch
			set @errornumber = ERROR_NUMBER();
			set @errorprocedure = ERROR_PROCEDURE();
			set @errorline = ERROR_LINE();
			set @errormessage = ERROR_MESSAGE();

			exec errorlog_ins 
				 @errornumber,
				 @errorprocedure,
				 @errorline,
				 @errormessage;
		end catch
	end
END
GO

