USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_emp_calenderdays_ins_upd_del]    Script Date: 31-10-2025 16:41:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_emp_calenderdays_ins_upd_del]
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
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);
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
			Select emp_calender_id,fin_year_id,month_id,month_days,emp_holidays,emp_weekend,created_date,updated_date,user_id
			from emp_calenderdays;
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
			Select emp_calender_id,fin_year_id,month_id,month_days,emp_holidays,emp_weekend,created_date,updated_date,user_id
			from emp_calenderdays
			where emp_calender_id = @emp_calender_id;
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

