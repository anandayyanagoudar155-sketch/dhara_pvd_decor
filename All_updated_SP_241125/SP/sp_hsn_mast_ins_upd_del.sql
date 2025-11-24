USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_hsn_mast_ins_upd_del]    Script Date: 24-11-2025 19:59:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_hsn_mast_ins_upd_del](
@action varchar(max),
@hsn_id bigint=0,
@hsn_code varchar(10)='',
@cgst_perc decimal(5,2)=0,
@sgst_perc decimal(5,2)=0,
@igst_perc decimal(5,2)=0,
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
			if EXISTS (Select 1 from hsn_mast where hsn_code = @hsn_code)
			Begin
					RAISERROR('Cannot insert: hsn_code is already present', 16, 1);
					return;
			End
			insert into hsn_mast(hsn_code,cgst_perc,sgst_perc,igst_perc,created_date,updated_date,user_id)
			values(@hsn_code,@cgst_perc,@sgst_perc,@igst_perc,@created_date,@updated_date,@user_id);
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
                select count(hsn_id) from product_mast where hsn_id = @hsn_id
            ) 
		);
		
		if @rec_count > 0
		begin
			rollback transaction;
			RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
			return;
		end

		delete from hsn_mast where hsn_id=@hsn_id
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
			if not EXISTS (Select 1 from user_mast where user_id = @user_id)
			Begin
					RAISERROR('Cannot update: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from hsn_mast where hsn_code = @hsn_code and hsn_id <>@hsn_id)
			Begin
					RAISERROR('Cannot update: hsn_code is already present', 16, 1);
					return;
			End
			update hsn_mast
			set
			hsn_code=@hsn_code,
			cgst_perc=@cgst_perc,
			sgst_perc=@sgst_perc,
			igst_perc=@igst_perc,
			created_date=@created_date,
			updated_date=@updated_date,
			user_id=@user_id
			where hsn_id=@hsn_id;
				
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
		select hm.hsn_id,hm.hsn_code,hm.cgst_perc,hm.sgst_perc,hm.igst_perc,hm.created_date,hm.updated_date,um.user_name 
		from hsn_mast hm
		left join user_mast um on hm.user_id=um.user_id;
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
		select hsn_id,hsn_code,cgst_perc,sgst_perc,igst_perc,created_date,updated_date,user_id from hsn_mast where hsn_id=@hsn_id;
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



if @action = 'hsnlist'
begin
	begin try
		select hsn_id,hsn_code from hsn_mast;
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

