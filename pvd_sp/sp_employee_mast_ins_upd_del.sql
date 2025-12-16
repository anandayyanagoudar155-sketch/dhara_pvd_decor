USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_employee_mast_ins_upd_del]    Script Date: 16-12-2025 16:09:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE procedure [dbo].[sp_employee_mast_ins_upd_del]
(
@action varchar(max) = '',
@employee_id bigint = 0,
@desg_id bigint = 0,
@first_name varchar(100) = '', 
@last_name varchar(100) = '',
@gender varchar(10) = '',
@dob date = null,  
@phone_number varchar(12) = '',  
@emailid varchar(max) = '',
@address varchar(max) = '', 
@city_id bigint = 0,
@aadhaar_number varchar(15) = '',
@pan_number varchar(12) = '',
@bankaccount_no  varchar(20) = '',
@ifsc_code varchar(8) = '',
@joining_date  date = null,
@relieving_date date = null,
@education varchar(100) = '',
@exp_year decimal(5,2) = 0,
@annual_salary decimal(12,2) = 0,
@active_status bit = 0, 
@created_date date = null,
@updated_date date = null,
@fin_year_id bigint = 0,
@comp_id bigint = 0,
@created_by bigint = 0,
@modified_by bigint = 0
)
as
BEGIN
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);
	if @action = 'insert'
	begin
		begin try
			begin transaction
			if not EXISTS (Select 1 from employee_desg_mast where desg_id = @desg_id)
			Begin
					RAISERROR('Cannot insert: desg_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from city_mast where city_id = @city_id)
			Begin
					RAISERROR('Cannot insert: city_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from fin_year_mast where fin_year_id = @fin_year_id)
			Begin
					RAISERROR('Cannot insert: fin_year_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from company_mast where comp_id = @comp_id)
			Begin
					RAISERROR('Cannot insert: comp_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from user_mast where user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			insert into employee_mast(desg_id,first_name,last_name,gender,dob,phone_number,emailid,[address],
			city_id,aadhaar_number,pan_number,bankaccount_no,ifsc_code,joining_date,relieving_date,education,
			exp_year,annual_salary,active_status,created_date,updated_date,fin_year_id,comp_id,created_by,modified_by)
			values(@desg_id,@first_name,@last_name,@gender,@dob,@phone_number,@emailid,@address,@city_id,
			@aadhaar_number,@pan_number,@bankaccount_no,@ifsc_code,@joining_date,@relieving_date,@education,
			@exp_year,@annual_salary,@active_status,@created_date,@updated_date,@fin_year_id,@comp_id,@created_by,@modified_by);
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
			Select em.employee_id,edm.desg_name,em.first_name,em.last_name,em.gender,em.dob,em.phone_number,
			em.emailid,em.[address],cm.city_name,em.aadhaar_number,em.pan_number,em.bankaccount_no,
			em.ifsc_code,em.joining_date,em.relieving_date,em.education,em.exp_year,em.annual_salary,
			em.active_status,em.created_date,em.updated_date,fym.fin_name,cpm.comp_name,um.user_name
			from employee_mast em
			left join user_mast um on em.created_by = um.user_id
			left join employee_desg_mast edm on em.desg_id = edm.desg_id
			left join fin_year_mast fym on em.fin_year_id = fym.fin_year_id
			left join company_mast cpm on em.comp_id = cpm.comp_id
			left join city_mast cm on em.city_id = cm.city_id;
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
			Select em.employee_id,em.desg_id,em.first_name,em.last_name,em.gender,em.dob,em.phone_number,
			em.emailid,em.[address],em.city_id,em.aadhaar_number,em.pan_number,em.bankaccount_no,
			em.ifsc_code,em.joining_date,em.relieving_date,em.education,em.exp_year,em.annual_salary,
			em.active_status,em.created_date,em.updated_date,em.fin_year_id,em.comp_id,em.created_by,em.modified_by
			from employee_mast em
			where em.employee_id = @employee_id;
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
	declare @rec_count bigint;
		begin try
			begin transaction
			set @rec_count = (
								Select sum(cnt) from
								(
									Select count(employee_id) as cnt from emp_leave_mast where employee_id = @employee_id 
									union all
									Select count(employee_id) as cnt from employee_payslip where employee_id = @employee_id
								) as rec_count
							 );

			if @rec_count > 0
			begin
				rollback transaction;
				RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
				return;
			end
			delete from employee_mast where employee_id = @employee_id;
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
			if not EXISTS (Select 1 from employee_desg_mast where desg_id = @desg_id)
			Begin
					RAISERROR('Cannot insert: desg_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from city_mast where city_id = @city_id)
			Begin
					RAISERROR('Cannot insert: city_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from fin_year_mast where fin_year_id = @fin_year_id)
			Begin
					RAISERROR('Cannot insert: fin_year_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from company_mast where comp_id = @comp_id)
			Begin
					RAISERROR('Cannot insert: comp_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from user_mast where user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			update employee_mast
			set desg_id = @desg_id,
				first_name = @first_name,
				last_name = @last_name,
				gender = @gender,
				dob = @dob,
				phone_number = @phone_number,
				emailid = @emailid,
				[address] = @address,
				city_id = @city_id,
				aadhaar_number = @aadhaar_number,
				pan_number = @pan_number,
				bankaccount_no = @bankaccount_no,
				ifsc_code = @ifsc_code,
				joining_date = @joining_date,
				relieving_date = @relieving_date,
				education = @education,
				exp_year = @exp_year,
				annual_salary = @annual_salary,
				active_status = @active_status,
				created_date = @created_date,
				updated_date = @updated_date,
				fin_year_id = @fin_year_id,
				comp_id = @comp_id,
				created_by = @created_by,
				modified_by=@modified_by
			where employee_id = @employee_id;

			if @@ROWCOUNT = 0
			begin
				rollback transaction;
				return;
			end
			commit transaction;
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
	if @action = 'employee_mastlist'
	begin
		begin try
			select employee_id,first_name,last_name from employee_mast;
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
END
GO

