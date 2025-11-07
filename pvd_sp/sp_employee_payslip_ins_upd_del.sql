USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_employee_payslip_ins_upd_del]    Script Date: 07-11-2025 09:43:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_employee_payslip_ins_upd_del](
@action varchar(max) = '',
@emp_payslip_id bigint ,
@fin_year_id bigint,
@month_id bigint,
@company_id bigint,
@employee_id bigint,
@emp_calender_id bigint,
@employee_working_days decimal(4,2),
@actual_working_days decimal(4,2),
@actual_working_hours decimal(5,2),
@monthly_salary decimal(12,2),
@hourly_salary decimal(12,2),
@over_time_hours decimal(5,2),
@over_time_amount decimal(12,2),
@gross_amount decimal(12,2),
@pf_amount decimal(12,2),
@tds_amount decimal(12,2),
@advance_amount decimal(12,2),
@netamount decimal(12,2),
@remarks varchar(100),
@created_date date,
@updated_date date,
@user_id bigint
)
as
Begin
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);

	if @action = 'insert'
	begin
		begin try
			begin transaction
			insert into employee_payslip(fin_year_id,month_id,company_id,employee_id,emp_calender_id,
			employee_working_days,actual_working_days,monthly_salary,hourly_salary,over_time_hours,over_time_amount,
			gross_amount,pf_amount,tds_amount,advance_amount,netamount,remarks,created_date,updated_date,
			user_id)
			values(@fin_year_id,@month_id,@company_id,@employee_id,@emp_calender_id,@employee_working_days,
			@actual_working_days,@monthly_salary,@hourly_salary,@over_time_hours,@over_time_amount,@gross_amount,
			@pf_amount,@tds_amount,@advance_amount,@netamount,@remarks,@created_date,@updated_date,@user_id);
			commit transaction;
		end try
		begin catch
			IF XACT_STATE() <> 0
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
			Select ep.emp_payslip_id,fym.fin_name,mm.month_name,cm.comp_name,em.first_name,em.last_name,ecd.emp_calender_id,ep.employee_working_days,
			ep.actual_working_days,ep.monthly_salary,ep.hourly_salary,ep.over_time_hours,ep.over_time_amount,ep.gross_amount,
			ep.pf_amount,ep.tds_amount,ep.advance_amount,ep.netamount,ep.remarks,ep.created_date,ep.updated_date,um.user_name
			from employee_payslip ep 
			left join employee_mast em on ep.employee_id=em.employee_id
			left join user_mast um on ep.user_id = um.user_id
			left join fin_year_mast fym on ep.fin_year_id = fym.fin_year_id
			left join month_mast mm on ep.month_id = mm.month_id
			left join company_mast cm on ep.company_id=cm.comp_id
			left join emp_calenderdays ecd on ep.emp_calender_id=ecd.emp_calender_id;
			
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
			Select ep.emp_payslip_id,fym.fin_name,mm.month_name,cm.comp_name,em.first_name,em.last_name,ecd.emp_calender_id,ep.employee_working_days,
			ep.actual_working_days,ep.monthly_salary,ep.hourly_salary,ep.over_time_hours,ep.over_time_amount,ep.gross_amount,
			ep.pf_amount,ep.tds_amount,ep.advance_amount,ep.netamount,ep.remarks,ep.created_date,ep.updated_date,um.user_name
			from employee_payslip ep 
			left join employee_mast em on ep.employee_id=em.employee_id
			left join user_mast um on ep.user_id = um.user_id
			left join fin_year_mast fym on ep.fin_year_id = fym.fin_year_id
			left join month_mast mm on ep.month_id = mm.month_id
			left join company_mast cm on ep.company_id=cm.comp_id
			left join emp_calenderdays ecd on ep.emp_calender_id=ecd.emp_calender_id
			where ep.emp_payslip_id=@emp_payslip_id;
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
		begin try
			begin transaction;
			
			delete from employee_payslip where emp_payslip_id = @emp_payslip_id;
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
				 
			THROW;
		end catch
	end

	if @action = 'update'
	begin
		begin try
			begin transaction
			update employee_payslip
			set fin_year_id = @fin_year_id,
				month_id = @month_id,
				company_id = @company_id,
				employee_id = @employee_id,
				emp_calender_id = @emp_calender_id,
				employee_working_days = @employee_working_days,
				actual_working_days = @actual_working_days,
				actual_working_hours = @actual_working_hours,
				monthly_salary = @monthly_salary,
				hourly_salary = @hourly_salary,
				over_time_hours = @over_time_hours,
				over_time_amount = @over_time_amount,
				gross_amount = @gross_amount,
				pf_amount = @pf_amount,
				tds_amount = @tds_amount,
				advance_amount = @advance_amount,
				netamount = @netamount,
				remarks = @remarks,
				created_date = @created_date,
				updated_date = @updated_date,
				user_id = @user_id
			where emp_payslip_id = @emp_payslip_id;

			if @@ROWCOUNT = 0
			begin
				rollback transaction;
				return;
			end

			commit transaction;
		end try
		begin catch
			IF XACT_STATE() <> 0 
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
	
End
GO

