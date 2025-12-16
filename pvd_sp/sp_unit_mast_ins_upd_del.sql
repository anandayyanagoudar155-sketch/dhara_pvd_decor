USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_unit_mast_ins_upd_del]    Script Date: 16-12-2025 12:46:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_unit_mast_ins_upd_del](
@action varchar(max),
@unit_id bigint=0,
@unit_name varchar(50)='',
@unit_desc varchar(max)='',
@is_active bit=0,
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
			if EXISTS (Select 1 from unit_mast where unit_name = @unit_name)
			Begin
					RAISERROR('Cannot insert: unit_name is already present', 16, 1);
					return;
			End
			insert into unit_mast(unit_name,unit_desc,is_active,created_date,updated_date,created_by,modified_by)
			values(@unit_name,@unit_desc,@is_active,@created_date,@updated_date,@created_by,@modified_by)
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
		set @rec_count = ( select sum(cnt)
			from (
            select count(unit_id) as cnt from product_mast where unit_id = @unit_id
			union all
            select count(unit_id) as cnt from salesinvoicedetails where unit_id = @unit_id
			union all
            select count(unit_id) as cnt from PurchaseInvoice_Details where unit_id = @unit_id
			union all
            select count(unit_id) as cnt from dailyconsumption_mast where unit_id = @unit_id
		) as rec_count);
		
		if @rec_count > 0
		begin
			rollback transaction;
			RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
			return;
		end

		delete from unit_mast where unit_id=@unit_id
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
			if EXISTS (Select 1 from unit_mast where unit_name = @unit_name and unit_id <> @unit_id)
			Begin
					RAISERROR('Cannot update: unit_name is already present', 16, 1);
					return;
			End
			update unit_mast 
			set unit_name=@unit_name,
			unit_desc=@unit_desc,
			is_active=@is_active,
			created_date=@created_date,
			updated_date=@updated_date,
			created_by=@created_by,
			modified_by=@modified_by
				where unit_id=@unit_id
				
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
		select um.unit_id,um.unit_name,um.unit_desc,um.is_active,um.created_date,um.updated_date,usm.user_name 
		from unit_mast um
		left join user_mast usm on um.created_by=usm.user_id;
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
				select unit_id,unit_name,unit_desc,is_active,created_date,updated_date,created_by,modified_by from unit_mast where unit_id=@unit_id;
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



if @action = 'unitlist'
begin
	begin try
		select unit_id,unit_name from unit_mast
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

