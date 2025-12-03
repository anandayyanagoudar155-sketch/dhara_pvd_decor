USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_employee_payslip_ins_upd_del]    Script Date: 03-12-2025 18:05:29 ******/
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
set @employee_working_days = isnull((Select (month_days - (emp_holidays + emp_weekend)) as monthly_working_days from emp_calenderdays where emp_calender_id = @emp_calender_id),0);
set @actual_working_days = isnull((@employee_working_days - (Select count(1)
														from emp_leave_mast
														where employee_id = @employee_id and
														fin_year_id = @fin_year_id and
														month_id = @month_id
														)),0);
set @actual_working_hours = isnull((@actual_working_days * 8),0);
set @monthly_salary = isnull(((Select annual_salary from employee_mast where employee_id = @employee_id)/12),0);
set @hourly_salary = isnull((@monthly_salary/(@employee_working_days * 8)),0);
set @over_time_amount = isnull((@over_time_hours * @hourly_salary),0);
set @gross_amount = isnull(((@actual_working_hours * @hourly_salary) + @over_time_amount),0);
set @netamount = isnull(((@gross_amount + @pf_amount) - (@tds_amount + @advance_amount)),0);


	if @action = 'insert'
	begin
		begin try
			begin transaction
			insert into employee_payslip(fin_year_id,month_id,company_id,employee_id,emp_calender_id,
			employee_working_days,actual_working_days,actual_working_hours,monthly_salary,hourly_salary,over_time_hours,over_time_amount,
			gross_amount,pf_amount,tds_amount,advance_amount,netamount,remarks,created_date,updated_date,
			user_id)
			values(@fin_year_id,@month_id,@company_id,@employee_id,@emp_calender_id,@employee_working_days,
			@actual_working_days,@actual_working_hours,@monthly_salary,@hourly_salary,@over_time_hours,@over_time_amount,@gross_amount,
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
			ep.actual_working_days,ep.actual_working_hours,ep.monthly_salary,ep.hourly_salary,ep.over_time_hours,ep.over_time_amount,ep.gross_amount,
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
			ep.actual_working_days,ep.actual_working_hours,ep.monthly_salary,ep.hourly_salary,ep.over_time_hours,ep.over_time_amount,ep.gross_amount,
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
			declare @rec_count bigint;

			 set @rec_count = (
									Select sum(cnt) from
									(
										Select count(emp_payslip_id) as cnt from payment_mast where emp_payslip_id=@emp_payslip_id
										union all
										Select count(emp_payslip_id) as cnt from payment_details pd inner join
										payment_mast pm on pd.payment_id =pm.payment_id  
										where emp_payslip_id=@emp_payslip_id
								    ) as rec_count
							  );
			if @rec_count>0
			begin
				rollback transaction;
				RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
				return;
			end
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

			declare @payment_id bigint;
			set @payment_id = isnull((select payment_id from payment_mast where emp_payslip_id = @emp_payslip_id),0)

			update payment_mast
			set net_total = @netamount,
			balance_total = isnull(@netamount - (
										  Select sum(pd.total_amount) as cnt 
										  from payment_details pd inner join
										  payment_mast pm on pd.payment_id =pm.payment_id  
										  where pd.payment_id=@payment_id
										 ),0)
			where emp_payslip_id = @emp_payslip_id;

			/*if @@ROWCOUNT = 0
			begin
				rollback transaction;
				return;
			end*/

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

