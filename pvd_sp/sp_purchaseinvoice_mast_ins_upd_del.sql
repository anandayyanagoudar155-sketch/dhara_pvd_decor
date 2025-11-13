USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_purchaseinvoice_mast_ins_upd_del]    Script Date: 13-11-2025 17:05:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE procedure [dbo].[sp_purchaseinvoice_mast_ins_upd_del](
@action varchar(max) = '',
@purchase_id bigint = 0,
@prefix varchar(6) = '',
@suffix varchar(6) = '',
@invoive_no varchar(16) = '',
@purchase_date date = null,
@vendor_id bigint = 0,
@gross_total decimal(12,2) = 0,
@sgst_total decimal(12,2) = 0,
@cgst_total decimal(12,2) = 0,
@igst_total decimal(12,2) = 0,
@discount_total decimal(12,2) = 0,
@roundoff_total decimal(12,2) = 0,
@net_total decimal(12,2) = 0,
@balance_total decimal(12,2) = 0,
@paymentstatus bit = 0,
@is_active bit = 1,
@fin_year_id bigint = 0,
@comp_id bigint = 0,
@created_date date = null,
@updated_date date = null,
@user_id bigint = 0
)
as
Begin
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);
set @net_total = (@gross_total + @sgst_total + @cgst_total + @igst_total) - @discount_total + @roundoff_total;
set @balance_total = @net_total

	if @action = 'insert'
	begin
		

		begin try
			begin transaction
			insert into purchaseinvoice_mast(prefix,suffix,invoive_no,purchase_date,vendor_id,gross_total,
			sgst_total,cgst_total,igst_total,discount_total,roundoff_total,net_total,balance_total,paymentstatus,
			is_active,fin_year_id,comp_id,created_date,updated_date,user_id)
			values(@prefix,@suffix,@invoive_no,@purchase_date,@vendor_id,@gross_total,@sgst_total,
			@cgst_total,@igst_total,@discount_total,@roundoff_total,@net_total,@balance_total,@paymentstatus,
			@is_active,@fin_year_id,@comp_id,@created_date,@updated_date,@user_id);
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
			Select pim.purchase_id,pim.prefix,pim.suffix,pim.invoive_no,pim.purchase_date,vm.vendor_name,
			pim.gross_total,pim.sgst_total,pim.cgst_total,pim.igst_total,pim.discount_total,pim.roundoff_total,
			pim.net_total,pim.balance_total,pim.paymentstatus,pim.is_active,fym.fin_name,cm.comp_name,pim.created_date,
			pim.updated_date,um.user_name
			from purchaseinvoice_mast pim
			left join user_mast um on pim.user_id = um.user_id
			left join company_mast cm on pim.comp_id = cm.comp_id
			left join fin_year_mast fym on pim.fin_year_id = fym.fin_year_id
			left join vendor_mast vm on pim.vendor_id = vm.vendor_id;
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
			Select pim.purchase_id,pim.prefix,pim.suffix,pim.invoive_no,pim.purchase_date,pim.vendor_id,
			pim.gross_total,pim.sgst_total,pim.cgst_total,pim.igst_total,pim.discount_total,pim.roundoff_total,
			pim.net_total,pim.balance_total,pim.paymentstatus,pim.is_active,pim.fin_year_id,pim.comp_id,pim.created_date,
			pim.updated_date,pim.user_id
			from purchaseinvoice_mast pim
			where pim.purchase_id=@purchase_id;
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
		declare @rec_count bigint = 0
		begin try
			begin transaction;
			set @rec_count =(
								Select sum(cnt) from 
								(
									Select count(purchase_id) as cnt from purchaseinvoice_details where purchase_id = @purchase_id
									union all
									Select count(purchase_id) as cnt from payment_mast	where purchase_id = @purchase_id							
								) as rec_count
							);

			if @rec_count>0
			begin
				rollback transaction;
				RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
				return;
			end

			delete from purchaseinvoice_mast where purchase_id = @purchase_id;
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
			update purchaseinvoice_mast
			set prefix = @prefix,
				suffix = @suffix,
				invoive_no = @invoive_no,
				purchase_date = @purchase_date,
				vendor_id = @vendor_id,
				gross_total = @gross_total,
				sgst_total = @sgst_total,
				cgst_total = @cgst_total,
				igst_total = @igst_total,
				discount_total = @discount_total,
				roundoff_total = @roundoff_total,
				net_total = @net_total,
				balance_total = @balance_total,
				paymentstatus = @paymentstatus,
				is_active = @is_active,
				fin_year_id = @fin_year_id,
				comp_id = @comp_id,
				created_date = @created_date,
				updated_date = @updated_date,
				user_id = @user_id
			where purchase_id = @purchase_id;

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

