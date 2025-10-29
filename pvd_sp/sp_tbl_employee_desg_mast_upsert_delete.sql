USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_tbl_employee_desg_mast_upsert_delete]    Script Date: 29-10-2025 15:45:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_tbl_employee_desg_mast_upsert_delete]
(
@action varchar(max) = '',
@desg_id bigint = 0,
@desg_name varchar(50) = '',
@desg_desc varchar(50) = '',
@daily_wk_hr decimal(5,2) = 0,
@created_date date = null,
@updated_date date = null,
@user_id bigint =0
)
as
BEGIN
declare @ErrorNumber bigint,@ErrorProcedure nvarchar(128),@ErrorLine bigint,@ErrorMessage nvarchar(max);
	if @action = 'insert'
	begin
		begin try
			begin transaction
			insert into employee_desg_mast(desg_name,desg_desc,daily_wk_hr,created_date,updated_date,user_id)
			values(@desg_name,@desg_desc,@daily_wk_hr,@created_date,@updated_date,@user_id);
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
	if @action = 'Select All'
	begin
		begin try
			Select desg_id,desg_name,desg_desc,daily_wk_hr,created_date,updated_date,user_id
			from employee_desg_mast;
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
			Select desg_id,desg_name,desg_desc,daily_wk_hr,created_date,updated_date,user_id
			from employee_desg_mast
			where desg_id = @desg_id;
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
								Select count(desg_id) from employee_mast where desg_id = @desg_id
							 )
			if @rec_count > 0
			begin
				rollback transaction;
				return;
			end
			delete from employee_desg_mast where desg_id = @desg_id;
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
			update employee_desg_mast
			set desg_name = @desg_name,
				desg_desc = @desg_desc,
				daily_wk_hr = @daily_wk_hr,
				updated_date = @updated_date,
				user_id = @user_id
			where desg_id = @desg_id;

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
	if @action = 'drop down'
	begin
		begin try
			Select desg_id,desg_name
			from employee_desg_mast;
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
END
GO

