USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_emp_calenderdays_upsert_delete]    Script Date: 29-10-2025 15:43:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_emp_calenderdays_upsert_delete]
(
@action varchar(max) = '',
@emp_calender_id bigint = 0,
@fin_year_id bigint = 0,
@month_id bigint = 0,
@month_days decimal(5,2) = 0,
@emp_holidays decimal(5,2) = 0,
@emp_weekend decimal(5,2) = 0,
@created_date date = null,
@updated_date date = null,
@user_id bigint = 0
)
as
BEGIN
declare @ErrorNumber int,@ErrorProcedure nvarchar(128),@ErrorLine int,@ErrorMessage nvarchar(max);
	if @action = 'insert'
	begin
		begin try
			begin transaction
			insert into emp_calenderdays(fin_year_id,month_id,month_days,emp_holidays,emp_weekend,created_date,updated_date,user_id)
			values(@fin_year_id,@month_id,@month_days,@emp_holidays,@emp_weekend,@created_date,@updated_date,@user_id);
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
	if @action = 'Select All'
	begin
		begin try
			Select emp_calender_id,fin_year_id,month_id,month_days,emp_holidays,emp_weekend,created_date,updated_date,user_id
			from emp_calenderdays;
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
			Select emp_calender_id,fin_year_id,month_id,month_days,emp_holidays,emp_weekend,created_date,updated_date,user_id
			from emp_calenderdays
			where emp_calender_id = @emp_calender_id;
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
	declare @rec_count int;
		begin try
			begin transaction
			set @rec_count = (
								Select count(emp_calender_id) from employee_payslip where emp_calender_id = @emp_calender_id
							 );
			if @rec_count > 0
			begin
				rollback transaction;
				return;
			end
			delete from emp_calenderdays where emp_calender_id = @emp_calender_id;
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
	if @action = 'update'
	begin
		begin try
			begin transaction
			update emp_calenderdays
			set fin_year_id = @fin_year_id,
				month_id = @month_id,
				month_days = @month_days,
				emp_holidays = @emp_holidays,
				emp_weekend = @emp_weekend,
				updated_date = @updated_date,
				user_id = @user_id
			where emp_calender_id = @emp_calender_id;

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

