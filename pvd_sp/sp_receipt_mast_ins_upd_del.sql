USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_receipt_mast_ins_upd_del]    Script Date: 13-11-2025 11:06:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_receipt_mast_ins_upd_del](
@action varchar(max),
@receipt_id bigint=0,
@sales_id bigint=0,
@recepit_date date=null,
@net_total decimal(12,2)=0,
@balance_amount decimal(12,2)=0,
@receipt_status bit=0,
@fin_year_id bigint=0,
@comp_id bigint=0,
@created_date date=null,
@updated_date date=null,
@user_id bigint=0
)
as
begin

declare @ErrorNumber int, @ErrorProcedure nvarchar(128), @ErrorLine int, @ErrorMessage nvarchar(max);
set @net_total = (Select sum(net_total) from salesinvoice_mast where sales_id = @sales_id);
set @balance_amount = @net_total;

if @action='insert'
begin
	begin try
		begin transaction
			insert into receipt_mast(sales_id,recepit_date,net_total,balance_amount,receipt_status,fin_year_id,comp_id,created_date,updated_date,user_id)
			values(@sales_id,@recepit_date,@net_total,@balance_amount,@receipt_status,@fin_year_id,@comp_id,@created_date,@updated_date,@user_id)
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
                select count(receipt_id) from receipt_details where receipt_id = @receipt_id
            ) 
		);
		
		if @rec_count > 0
		begin
			rollback transaction;
			RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
			return;
		end

		delete from receipt_mast where receipt_id=@receipt_id
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
			update receipt_mast 
			set sales_id=@sales_id,
			recepit_date=@recepit_date,
			net_total=@net_total,
			balance_amount=@balance_amount,
			receipt_status=@receipt_status,
			fin_year_id=@fin_year_id,
			comp_id=@comp_id,
			created_date=@created_date,
			updated_date=@updated_date,
			user_id=@user_id
				where receipt_id=@receipt_id
				
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
		select rm.receipt_id,sim.sales_id,rm.recepit_date,rm.net_total,rm.balance_amount,rm.receipt_status,fym.fin_name,
		cm.comp_name,rm.created_date,rm.updated_date,um.user_name 
		from receipt_mast rm
		left join salesinvoice_mast sim on rm.sales_id=sim.sales_id
		left join fin_year_mast fym on rm.fin_year_id=fym.fin_year_id
		left join company_mast cm on rm.comp_id=cm.comp_id
		left join user_mast um on rm.user_id=um.user_id; 	
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
		select receipt_id,sales_id,recepit_date,net_total,balance_amount,receipt_status,fin_year_id,comp_id,created_date,updated_date,user_id from receipt_mast where receipt_id=@receipt_id; 	
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
	
	

if @action = 'receiptlist'
begin
	begin try
		select receipt_id,sales_id from receipt_mast
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

