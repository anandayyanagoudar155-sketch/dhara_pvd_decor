USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_purchaseinvoice_mast_ins_upd_del]    Script Date: 16-12-2025 15:37:20 ******/
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
@created_by bigint = 0,
@modified_by bigint = 0
)
as
Begin
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);


	if @action = 'insert'
	begin
		

		begin try
			begin transaction

			if not EXISTS (Select 1 from vendor_mast where vendor_id = @vendor_id)
			Begin
					RAISERROR('Cannot insert: vendor_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from fin_year_mast where fin_year_id = @fin_year_id)
			Begin
					RAISERROR('Cannot insert: fin_year_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from company_mast where comp_id = @comp_id)
			Begin
					RAISERROR('Cannot insert: comp_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from user_mast where user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End

			SET @net_total = 
			isnull((@gross_total 
			 + @sgst_total 
			 + @cgst_total 
			 + @igst_total)
			- @discount_total
			,0);

			set @balance_total = @net_total;
			set @roundoff_total = isnull((ROUND(@net_total,0)),0);
			
			insert into purchaseinvoice_mast(prefix,suffix,invoive_no,purchase_date,vendor_id,gross_total,
			sgst_total,cgst_total,igst_total,discount_total,roundoff_total,net_total,balance_total,paymentstatus,
			is_active,fin_year_id,comp_id,created_date,updated_date,created_by,modified_by)
			values(@prefix,@suffix,@invoive_no,@purchase_date,@vendor_id,@gross_total,@sgst_total,
			@cgst_total,@igst_total,@discount_total,@roundoff_total,@net_total,@balance_total,@paymentstatus,
			@is_active,@fin_year_id,@comp_id,@created_date,@updated_date,@created_by,@modified_by);
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
			left join user_mast um on pim.created_by = um.user_id
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
			pim.updated_date,pim.created_by,pim.modified_by
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
		declare @rec_count bigint;
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
				gross_total=isnull((select SUM(gross_amt) from purchaseinvoice_details where purchase_id = @purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				sgst_total=isnull((select SUM(sgst_amt)  from purchaseinvoice_details where purchase_id = @purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				cgst_total=isnull((select SUM(cgst_amt)  from purchaseinvoice_details where purchase_id = @purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				igst_total=isnull((select SUM(igst_amt)  from purchaseinvoice_details where purchase_id = @purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				discount_total=isnull((select SUM(discount_amt) from purchaseinvoice_details where purchase_id = @purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				roundoff_total=ROUND(isnull((select SUM(total_amt) from purchaseinvoice_details where purchase_id = @purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),0),
				net_total = 
							ISNULL((SELECT SUM(total_amt) 
									FROM purchaseinvoice_details 
									WHERE purchase_id = @purchase_id 
									AND fin_year_id = @fin_year_id 
									AND comp_id = @comp_id), 0),
				balance_total =
								ISNULL((SELECT SUM(total_amt) 
										FROM purchaseinvoice_details 
										WHERE purchase_id = @purchase_id 
										AND fin_year_id = @fin_year_id 
										AND comp_id = @comp_id), 0)
								-
								ISNULL((SELECT SUM(rd.total_amount)
										FROM payment_details rd
										INNER JOIN payment_mast rm 
										ON rd.payment_id = rm.payment_id
										WHERE rm.purchase_id = @purchase_id
										AND rd.fin_year_id = @fin_year_id
										AND rd.comp_id = @comp_id), 0),
				paymentstatus = @paymentstatus,
				is_active = @is_active,
				fin_year_id = @fin_year_id,
				comp_id = @comp_id,
				created_date = @created_date,
				updated_date = @updated_date,
				created_by = @created_by,
				modified_by=@modified_by
				where purchase_id = @purchase_id;

			

			IF EXISTS (SELECT 1 FROM purchaseinvoice_mast WHERE purchase_id = @purchase_id and net_total>0)
			BEGIN
			IF EXISTS (SELECT 1 FROM purchaseinvoice_mast WHERE purchase_id = @purchase_id and balance_total=0 )
			BEGIN
				Update purchaseinvoice_mast
				set paymentstatus = 1
				where purchase_id = @purchase_id;
			END
			ELSE IF EXISTS (SELECT 1 FROM purchaseinvoice_mast WHERE purchase_id = @purchase_id and balance_total>0)
			BEGIN
				Update purchaseinvoice_mast
				set paymentstatus = 0
				where purchase_id = @purchase_id;
			END
			ELSE
			BEGIN
				Update purchaseinvoice_mast
				set paymentstatus = -1
				where purchase_id = @purchase_id;
			END
			END

			

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

