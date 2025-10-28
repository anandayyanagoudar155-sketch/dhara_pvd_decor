USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_tbl_month_mast_upsert_delete]    Script Date: 28-10-2025 16:25:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_tbl_month_mast_upsert_delete]
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
declare @ErrorNumber int,@ErrorProcedure nvarchar(128),@ErrorLine int,@ErrorMessage nvarchar(max)
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
			
			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec ErrorLog_Ins
				 @ErrorNumber,
				 @ErrorProcedure,
				 @ErrorLine,
				 @ErrorMessage;

		end catch
	end
	if @action = 'Select all'
	begin
		begin try
			Select month_id,month_name,start_date,end_date,created_date,updated_date,user_id  
			from month_mast;
		end try
		begin catch
			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec ErrorLog_Ins
				 @ErrorNumber,
				 @ErrorProcedure,
				 @ErrorLine,
				 @ErrorMessage;
		end catch
	end
	if @action = 'Select one'
	begin
		begin try
			select month_id,month_name,start_date,end_date,created_date,updated_date,user_id
			from month_mast
			where month_id=@month_id
		end try
		begin catch
			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec ErrorLog_Ins
				 @ErrorNumber,
				 @ErrorProcedure,
				 @ErrorLine,
				 @ErrorMessage;
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

			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec ErrorLog_Ins
				 @ErrorNumber,
				 @ErrorProcedure,
				 @ErrorLine,
				 @ErrorMessage;			
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

		set @ErrorNumber = ERROR_NUMBER();
		set @ErrorProcedure = ERROR_PROCEDURE();
		set @ErrorLine = ERROR_LINE();
		set @ErrorMessage = ERROR_MESSAGE();

		exec ErrorLog_Ins
			 @ErrorNumber,
			 @ErrorProcedure,
			 @ErrorLine,
			 @ErrorMessage
		end catch
	end
	if @action = 'drop down'
	begin
		begin try
			select month_id,month_name
			from month_mast;
		end try
		begin catch
			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec ErrorLog_Ins
				 @ErrorNumber,
				 @ErrorProcedure,
				 @ErrorLine,
				 @ErrorMessage;
		end catch
	end 
END
GO

