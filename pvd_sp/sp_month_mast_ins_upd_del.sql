USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_month_mast_ins_upd_del]    Script Date: 31-10-2025 16:46:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[sp_month_mast_ins_upd_del]
(
@action varchar(max) = '',
@month_id bigint = 0,
@month_name varchar(50) = '',
@start_date date = null,
@end_date date = null,
@created_date date = null,
@updated_date date = null,
@user_id bigint = 0
)
as
BEGIN
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);
	if @action = 'insert'
	begin
		begin try
			begin transaction
			insert into month_mast(month_name,start_date,end_date,created_date,updated_date,user_id)
			values(@month_name,@start_date,@end_date,@created_date,@updated_date,@user_id);
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
	if @action = 'select all'
	begin
		begin try
			Select month_id,month_name,start_date,end_date,created_date,updated_date,user_id  
			from month_mast;
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
			select month_id,month_name,start_date,end_date,created_date,updated_date,user_id
			from month_mast
			where month_id=@month_id
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
								Select count(month_id) from emp_calenderdays where month_id=@month_id
								union all
								Select count(month_id) from emp_leave_mast where month_id=@month_id
								union all
								Select count(month_id) from employee_payslip where month_id=@month_id
							 );
			if @rec_count > 0
			begin
				rollback transaction;
				return;
			end
			delete from month_mast where month_id = @month_id;
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
			update month_mast
			set month_name = @month_name,
				start_date = @start_date,
				end_date = @end_date,
				updated_date = @updated_date,
				@user_id = @user_id
			where user_id = @user_id

			if @@ROWCOUNT = 0
			 begin
				rollback transaction;
				return;
			 end

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
	if @action = 'month_mastlist'
	begin
		begin try
			select month_id,month_name
			from month_mast;
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

