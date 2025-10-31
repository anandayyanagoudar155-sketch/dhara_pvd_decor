USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_leavetype_mast_ins_upd_del]    Script Date: 31-10-2025 16:45:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[sp_leavetype_mast_ins_upd_del]
(
@action varchar(max) = '',
@leavetype_id bigint = 0,
@yearsincompany decimal(5,2) = 0,
@allocated_leaves decimal(5,2) = 0,
@leave_name varchar(100) = '',
@leave_desc varchar(max) = '',
@casual_leaves decimal(5,2) = 0,
@sick_leaves decimal(5,2) = 0,
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
			insert into leavetype_mast(yearsincompany,allocated_leaves,leave_name,leave_desc,casual_leaves,sick_leaves,created_date,updated_date,user_id)
			values(@yearsincompany,@allocated_leaves,@leave_name,@leave_desc,@casual_leaves,@sick_leaves,@created_date,@updated_date,@user_id);
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
			Select leavetype_id,yearsincompany,allocated_leaves,leave_name,leave_desc,casual_leaves,
			sick_leaves,created_date,updated_date,user_id
			from leavetype_mast;
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
			Select leavetype_id,yearsincompany,allocated_leaves,leave_name,leave_desc,casual_leaves,
			sick_leaves,created_date,updated_date,user_id
			from leavetype_mast
			where leavetype_id = @leavetype_id;
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
								Select count(leavetype_id) from emp_leave_mast where leavetype_id = @leavetype_id
							 );

			if @rec_count > 0
			begin
				rollback transaction;
				return;
			end
			delete from leavetype_mast where leavetype_id = @leavetype_id;
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
			update leavetype_mast
			set yearsincompany = @yearsincompany,
				allocated_leaves = @allocated_leaves,
				leave_name = @leave_name,
				leave_desc = @leave_desc,
				casual_leaves = @casual_leaves,
				sick_leaves = @sick_leaves,
				updated_date = @updated_date,
				user_id =@user_id
			where leavetype_id = @leavetype_id;

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
		end catch
	end
	if @action = 'leavetype_mastlist'
	begin
		begin try
			Select leavetype_id,leave_name
			from leavetype_mast;
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

