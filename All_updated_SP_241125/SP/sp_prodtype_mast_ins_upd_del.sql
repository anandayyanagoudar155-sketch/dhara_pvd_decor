USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_prodtype_mast_ins_upd_del]    Script Date: 24-11-2025 20:01:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[sp_prodtype_mast_ins_upd_del](
@action varchar(max),
@prodtype_id bigint=0,
@prodtype_name varchar(100)='',
@prodtype_desc varchar(max)='',
@created_date date=null,
@updated_date date=null,
@user_id bigint=0
)
as
begin

declare @ErrorNumber int, @ErrorProcedure nvarchar(128), @ErrorLine int, @ErrorMessage nvarchar(max);

if @action='insert'
begin
	begin try
		begin transaction
			if not EXISTS (Select 1 from user_mast where user_id = @user_id)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from prodtype_master where prodtype_name = @prodtype_name)
			Begin
					RAISERROR('Cannot insert: prodtype_name is already present', 16, 1);
					return;
			End
			insert into prodtype_master(prodtype_name,prodtype_desc,created_date,updated_date,user_id)
			values(@prodtype_name,@prodtype_desc,@created_date,@updated_date,@user_id)
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
                select count(prodtype_id) from product_mast where prodtype_id = @prodtype_id
            ) 
		);
		
		if @rec_count > 0
		begin
			rollback transaction;
			RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
			return;
		end

		delete from prodtype_master where prodtype_id=@prodtype_id;
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
			if not  EXISTS (Select 1 from user_mast where user_id = @user_id)
			Begin
					RAISERROR('Cannot update: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from prodtype_master where prodtype_name = @prodtype_name and prodtype_id <> @prodtype_id)
			Begin
					RAISERROR('Cannot update: prodtype_name is already present', 16, 1);
					return;
			End
			update prodtype_master
			set prodtype_name=@prodtype_name,
			prodtype_desc=@prodtype_desc,
			created_date=@created_date,
			updated_date=@updated_date,
			user_id=@user_id
			where prodtype_id=@prodtype_id;

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
		select ptm.prodtype_id,ptm.prodtype_name,ptm.prodtype_desc,ptm.created_date,ptm.updated_date,um.user_name 
		from prodtype_master ptm
		left join user_mast um on ptm.user_id=um.user_id;
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
		select prodtype_id,prodtype_name,prodtype_desc,created_date,updated_date,user_id from prodtype_master where prodtype_id=@prodtype_id;
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



if @action='prodtypelist'
begin
	begin try
		select prodtype_id,prodtype_name from prodtype_master;
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

