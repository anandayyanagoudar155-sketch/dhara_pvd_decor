USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_emp_leave_mast_ins_upd_del]    Script Date: 13-11-2025 10:55:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_emp_leave_mast_ins_upd_del](
@action varchar(max) = '',
@emp_leave_id bigint ,
@employee_id bigint,
@fin_year_id bigint,
@month_id bigint,
@emp_leave_date date,
@leavetype_id bigint,
@total_allocated_leaves decimal(4,2),
@leaves_used decimal(4,2),
@leaves_balance decimal(4,2),
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
			insert into emp_leave_mast(employee_id,fin_year_id,month_id,emp_leave_date,leavetype_id,
			total_allocated_leaves,leaves_used,leaves_balance,created_date,updated_date,
			user_id)
			values(@employee_id,@fin_year_id,@month_id,@emp_leave_date,@leavetype_id,@total_allocated_leaves,
			@leaves_used,@leaves_balance,@created_date,@updated_date,@user_id);
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
			Select elm.emp_leave_id,em.first_name,em.last_name,fym.fin_name,mm.month_name,elm.emp_leave_date,ltm.leave_name,
			elm.total_allocated_leaves,elm.leaves_used,elm.leaves_balance,elm.created_date,elm.updated_date,um.user_name
			from emp_leave_mast elm
			left join employee_mast em on elm.employee_id=elm.employee_id
			left join user_mast um on elm.user_id = um.user_id
			left join fin_year_mast fym on elm.fin_year_id = fym.fin_year_id
			left join month_mast mm on elm.month_id = mm.month_id
			left join leavetype_mast ltm on elm.leavetype_id=ltm.leavetype_id;
			
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
			Select elm.emp_leave_id,elm.employee_id,elm.fin_year_id,elm.month_id,elm.emp_leave_date,elm.leavetype_id,
			elm.total_allocated_leaves,elm.leaves_used,elm.leaves_balance,elm.created_date,elm.updated_date,elm.user_id
			from emp_leave_mast elm
			where elm.emp_leave_id=@emp_leave_id;
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
			
			delete from emp_leave_mast where emp_leave_id = @emp_leave_id;
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
			update emp_leave_mast
			set employee_id = @employee_id,
				fin_year_id = @fin_year_id,
				month_id = @month_id,
				emp_leave_date = @emp_leave_date,
				leavetype_id = @leavetype_id,
				total_allocated_leaves = @total_allocated_leaves,
				leaves_used = @leaves_used,
				leaves_balance = @leaves_balance,
				created_date = @created_date,
				updated_date = @updated_date,
				user_id = @user_id
			where emp_leave_id = @emp_leave_id;

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

