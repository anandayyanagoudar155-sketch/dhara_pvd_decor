USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_brand_mast_ins_upd_del]    Script Date: 16-12-2025 11:23:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_brand_mast_ins_upd_del](
@action varchar(max),
@brand_id bigint=0,
@brand_name varchar(100)='',
@brand_desc varchar(max)='',
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
			if not EXISTS (Select 1 from user_mast where user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from brand_mast where brand_name = @brand_name)
			Begin
					RAISERROR('Cannot insert: brand_name is already present', 16, 1);
					return;
			End
			insert into brand_mast(brand_name,brand_desc,created_date,updated_date,created_by,modified_by)
			values(@brand_name,@brand_desc,@created_date,@updated_date,@created_by,@modified_by);
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
                select count(brand_id) from product_mast where brand_id = @brand_id
            ) 
		);
		
		if @rec_count > 0
		begin
			rollback transaction;
			RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
			return;
		end

		delete from brand_mast where brand_id=@brand_id;
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

		if not EXISTS (Select 1 from user_mast where user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot update: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from brand_mast where brand_name = @brand_name and brand_id <> @brand_id)
			Begin
					RAISERROR('Cannot update: brand_name is already present', 16, 1);
					return;
			End

			update brand_mast 
			set brand_name=@brand_name,
			brand_desc=@brand_desc,
			created_date=@created_date,
			updated_date=@updated_date,
			created_by=@created_by,
			modified_by=@modified_by
			where brand_id=@brand_id
				
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
		select bm.brand_id,bm.brand_name,bm.brand_desc,bm.created_date,bm.updated_date,um.user_name 
		from brand_mast bm
		left join user_mast um on bm.created_by=um.user_id;
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
		select brand_id,brand_name,brand_desc,created_date,updated_date,created_by,modified_by from brand_mast where brand_id=@brand_id;
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



if @action='brandlist'
begin
	begin try
		select brand_id,brand_name from brand_mast;
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

