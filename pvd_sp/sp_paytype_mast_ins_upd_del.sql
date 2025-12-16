USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_paytype_mast_ins_upd_del]    Script Date: 16-12-2025 13:09:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_paytype_mast_ins_upd_del](
@action varchar(max),
@paytype_id bigint=0,
@paytype_name varchar(100)='',
@paytype_desc varchar(max)='',
@created_date date=null,
@updated_date date=null,
@created_by bigint=0,
@modified_by bigint=0
)
as
begin

declare @ErrorNumber int, @ErrorProcedure nvarchar(128), @ErrorLine int, @ErrorMessage nvarchar(max);


if @action='insert'
begin
	begin try
		begin transaction
			if not EXISTS (Select 1 from user_mast where  user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from paytype_mast where paytype_name = @paytype_name)
			Begin
					RAISERROR('Cannot insert: paytype_name is already present', 16, 1);
					return;
			End
			insert into paytype_mast(paytype_name,paytype_desc,created_date,updated_date,created_by,modified_by)
			values(@paytype_name,@paytype_desc,@created_date,@updated_date,@created_by,@modified_by)
		commit transaction;
	end try
		begin catch
			IF XACT_STATE() <> 0
			rollback transaction;

			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec errorlog_ins 
				 @ErrorNumber,
				 @ErrorProcedure,
				 @ErrorLine,
				 @ErrorMessage;	

			THROW;
		end catch
end



if @action='delete'
begin	
		declare @rec_count bigint
	begin try
		begin transaction;
		set @rec_count = (select 
            (
                select count(paytype_id) from receipt_details where paytype_id = @paytype_id
            )
		);
		
		if @rec_count > 0
		begin
			rollback transaction;
			RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
			return;
		end

		delete from paytype_mast where paytype_id=@paytype_id
		commit transaction;
	
	end try
		begin catch
			If XACT_STATE() <> 0
			rollback transaction;

			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec errorlog_ins
			@ErrorNumber,
			@ErrorProcedure,
			@ErrorLine,
			@ErrorMessage;
			
			THROW;
		end catch
end



if @action='update'
begin
	begin try
		begin transaction
			if not EXISTS (Select 1 from user_mast where  user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot update: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from paytype_mast where paytype_name = @paytype_name and paytype_id <> @paytype_id)
			Begin
					RAISERROR('Cannot update: paytype_name is already present', 16, 1);
					return;
			End
			update paytype_mast 
			set paytype_name=@paytype_name,
			paytype_desc=@paytype_desc,
			created_date=@created_date,
			updated_date=@updated_date,
			created_by=@created_by,
			modified_by=@modified_by
				where paytype_id=@paytype_id
			
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

			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec errorlog_ins
			@ErrorNumber,
			@ErrorProcedure,
			@ErrorLine,
			@ErrorMessage;
			
			THROW;
		end catch
end



if @action='selectall'
begin
	begin try
		select pty.paytype_id,pty.paytype_name,pty.paytype_desc,pty.created_date,pty.updated_date,um.user_name 
		from paytype_mast pty
		left join user_mast um on pty.created_by=um.user_id;
	end try
		begin catch
			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec errorlog_ins
			@ErrorNumber,
			@ErrorProcedure,
			@ErrorLine,
			@ErrorMessage;

			THROW;
		end catch
end


if @action='selectone'
begin
	begin try
		select paytype_id,paytype_name,paytype_desc,created_date,updated_date,created_by,modified_by from paytype_mast where paytype_id=@paytype_id;
	end try
		begin catch
			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec errorlog_ins
			@ErrorNumber,
			@ErrorProcedure,
			@ErrorLine,
			@ErrorMessage;

			THROW;
		end catch
end




if @action = 'paytypelist'
begin
	begin try
		select paytype_id,paytype_name from paytype_mast
	end try
	begin catch
		
		set @ErrorNumber = ERROR_NUMBER();
		set @ErrorProcedure = ERROR_PROCEDURE();
		set @ErrorLine = ERROR_LINE();
		set @ErrorMessage = ERROR_MESSAGE();

		exec errorlog_ins
		@ErrorNumber,
		@ErrorProcedure,
		@ErrorLine,
		@ErrorMessage;
		
		THROW;
	end catch
end

end
GO

