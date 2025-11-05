USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_emp_calenderdays_ins_upd_del]    Script Date: 05-11-2025 20:02:29 ******/
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

			THROW;
		end catch
	end
	if @action = 'select all'
	begin
		begin try
			Select ecd.emp_calender_id,fym.fin_name,mm.month_name,ecd.month_days,ecd.emp_holidays,
			ecd.emp_weekend,ecd.created_date,ecd.updated_date,um.user_name
			from emp_calenderdays ecd
			left join month_mast mm on ecd.month_id = mm.month_id
			left join fin_year_mast fym on ecd.fin_year_id = fym.fin_year_id
			left join user_mast um on ecd.user_id = um.user_id;
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

			THROW;
		end catch
	end
	if @action = 'select one'
	begin
		begin try
			Select ecd.emp_calender_id,ecd.fin_year_id,ecd.month_id,ecd.month_days,ecd.emp_holidays,
			ecd.emp_weekend,ecd.created_date,ecd.updated_date,ecd.user_id
			from emp_calenderdays ecd
			where ecd.emp_calender_id = @emp_calender_id;
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

			THROW;
		end catch
	end
	if @action = 'delete'
	begin
	declare @rec_count int;
		begin try
			begin transaction
			set @rec_count = (
								Select Sum(cnt) from
								(
									Select count(emp_calender_id) as cnt from employee_payslip where emp_calender_id = @emp_calender_id
								) as rec_count
							 );
			if @rec_count > 0
			begin
				rollback transaction;
				RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
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

			THROW;
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
				created_date = @created_date,
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

			THROW;
		end catch
	end
END
GO

