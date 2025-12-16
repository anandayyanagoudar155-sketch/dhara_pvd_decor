USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_emp_leave_mast_ins_upd_del]    Script Date: 16-12-2025 16:14:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE procedure [dbo].[sp_emp_leave_mast_ins_upd_del](
@action varchar(max) = '',
@emp_leave_id bigint =0 ,
@employee_id bigint=0,
@comp_id bigint=0,
@fin_year_id bigint=0,
@month_id bigint=0,
@emp_leave_date date=null,
@leavetype_id bigint=null,
@total_allocated_leaves decimal(4,2)=0,
@leaves_used decimal(4,2)=0,
@leaves_balance decimal(4,2)=0,
@created_date date=null,
@updated_date date=null,
@created_by bigint = 0,
@modified_by bigint = 0
)
as
Begin
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);


	if @action = 'insert'
	begin
		begin try
			begin transaction

			set @total_allocated_leaves = (Select allocated_leaves from leavetype_mast where leavetype_id = @leavetype_id);


			declare @inserted Table(emp_leave_id bigint);

			insert into emp_leave_mast(employee_id,comp_id,fin_year_id,month_id,emp_leave_date,leavetype_id,
			total_allocated_leaves,leaves_used,leaves_balance,created_date,updated_date,
			created_by,modified_by)
			OUTPUT inserted.emp_leave_id into @inserted
			values(@employee_id,@comp_id,@fin_year_id,@month_id,@emp_leave_date,@leavetype_id,@total_allocated_leaves,
			@leaves_used,@leaves_balance,@created_date,@updated_date,@created_by,@modified_by);

			set @leaves_used =(Select count(1) from emp_leave_mast where employee_id = @employee_id and fin_year_id = @fin_year_id and comp_id=@comp_id);
			set @leaves_balance = @total_allocated_leaves - @leaves_used;
			update emp_leave_mast
			set leaves_used = @leaves_used,
			  leaves_balance = @leaves_balance
			  where emp_leave_id = (Select emp_leave_id from @inserted);

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
			left join employee_mast em on elm.employee_id=em.employee_id
			left join user_mast um on elm.created_by = um.user_id
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
			elm.total_allocated_leaves,elm.leaves_used,elm.leaves_balance,elm.created_date,elm.updated_date,elm.created_by,elm.modified_by
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

			declare @em_id bigint;
			declare @lt_id int;
			set @em_id = (Select employee_id from emp_leave_mast where emp_leave_id = @emp_leave_id);
			--set @lt_id = (Select leavetype_id from emp_leave_mast where emp_leave_id = @emp_leave_id);
			--set @lt_id = (Select leavetype_id from emp_leave_mast where emp_leave_id = @emp_leave_id);
			set @total_allocated_leaves = (Select allocated_leaves from leavetype_mast where leavetype_id = @leavetype_id);
			set @leaves_used =(Select count(1) from emp_leave_mast where employee_id = @employee_id and fin_year_id =@fin_year_id and comp_id=@comp_id);
			set @leaves_balance = @total_allocated_leaves - @leaves_used;


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
				created_by = @created_by,
				modified_by = @modified_by
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

