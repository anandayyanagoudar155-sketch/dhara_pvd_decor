USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_leavetype_mast_upsert_delete]    Script Date: 29-10-2025 15:46:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_leavetype_mast_upsert_delete]
(
@action varchar(max) = '',
@leavetype_id bigint = 0,
@yearsincompany decimal(5,2) = 0,
@allocated_leaves decimal(5,2) = 0,
@leave_name varchar(50) = '',
@leave_description varchar(50) = '',
@casual_leaves decimal(5,2) = 0,
@sick_leaves decimal(5,2) = 0,
@created_date date = null,
@updated_date date = null,
@user_id bigint = 0
)
as
BEGIN
declare @ErrorNumber bigint,@ErrorProcedure nvarchar(128),@ErrorLine bigint,@ErrorMessage nvarchar(max);
	if @action = 'insert'
	begin
		begin try
			begin transaction
			insert into leavetype_mast(yearsincompany,allocated_leaves,leave_name,leave_description,casual_leaves,sick_leaves,created_date,updated_date,user_id)
			values(@yearsincompany,@allocated_leaves,@leave_name,@leave_description,@casual_leaves,@sick_leaves,@created_date,@updated_date,@user_id);
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
			Select leavetype_id,yearsincompany,allocated_leaves,leave_name,leave_description,casual_leaves,
			sick_leaves,created_date,updated_date,user_id
			from leavetype_mast;
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
			Select leavetype_id,yearsincompany,allocated_leaves,leave_name,leave_description,casual_leaves,
			sick_leaves,created_date,updated_date,user_id
			from leavetype_mast
			where leavetype_id = @leavetype_id;
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
			update leavetype_mast
			set yearsincompany = @yearsincompany,
				allocated_leaves = @allocated_leaves,
				leave_name = @leave_name,
				leave_description = @leave_description,
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
	if @action = 'drop down'
	begin
		begin try
			Select leavetype_id,leave_name
			from leavetype_mast;
		end try
		begin catch
			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine =ERROR_LINE();
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

