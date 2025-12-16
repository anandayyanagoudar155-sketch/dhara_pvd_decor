USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_salesinvoice_mast_ins_upd_del]    Script Date: 16-12-2025 14:53:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_salesinvoice_mast_ins_upd_del](
@action varchar(max),
@sales_id bigint=0,
@prefix varchar(6)='',
@suffix varchar(6)='',
@customer_id bigint=0,
@sales_date date=null,
@gross_total decimal(12,2)=0,
@sgst_total decimal(12,2)=0,
@cgst_total decimal(12,2)=0,
@igst_total decimal(12,2)=0,
@discount_total decimal(12,2)=0,
@roundoff_total decimal(12,2)=0,
@net_total decimal(12,2)=0,
@balance_total decimal(12,2)=0,
@payment_status bit=0,
@isactive bit=0,
@fin_year_id bigint=0,
@comp_id bigint=0,
@created_date date=null,
@updated_date date=null,
@created_by bigint=0,
@modified_by bigint=0
)
as
begin

declare @ErrorNumber int, @ErrorProcedure nvarchar(128), @ErrorLine int, @ErrorMessage nvarchar(max);
declare @pid bigint;
declare @fid bigint;
declare @cid bigint;

if @action='insert'
begin
	begin try
		begin transaction
		
			if not EXISTS (Select 1 from customer_mast where customer_id = @customer_id)
			Begin
					RAISERROR('Cannot insert: customer_id is incorrect', 16, 1);
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
		set @roundoff_total = isnull((ROUND(@net_total,0)),0)
		

			insert into salesinvoice_mast(prefix,suffix,customer_id,sales_date,gross_total,sgst_total,cgst_total,igst_total,discount_total,roundoff_total,net_total,balance_total,payment_status,isactive,fin_year_id,comp_id,created_date,updated_date,created_by,modified_by)
			values(@prefix,@suffix,@customer_id,@sales_date,@gross_total,@sgst_total,@cgst_total,@igst_total,@discount_total,@roundoff_total,@net_total,@balance_total,@payment_status,@isactive,@fin_year_id,@comp_id,@created_date,@updated_date,@created_by,@modified_by);

			
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

		set @rec_count = ( 
		select sum(cnt)
			from (
            select count(sales_id) as cnt  from salesinvoicedetails where sales_id = @sales_id 
			union all
            select count(sales_id) as cnt  from challan_mast where sales_id = @sales_id
			union all
            select count(sales_id) as cnt  from receipt_mast where sales_id = @sales_id
		) as recount);
		
		if @rec_count > 0
		begin
			rollback transaction;
			RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
			return;
		end

		delete from salesinvoice_mast where sales_id=@sales_id;

		
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

				
				
			if not EXISTS (Select 1 from customer_mast where customer_id = @customer_id)
			Begin
					RAISERROR('Cannot insert: customer_id is incorrect', 16, 1);
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
			update salesinvoice_mast
			set prefix=@prefix,
				suffix=@suffix,
				customer_id=@customer_id,
				sales_date=@sales_date,
				gross_total=isnull((select SUM(gross_amt) from salesinvoicedetails where sales_id = @sales_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				sgst_total=isnull((select SUM(sgst_amt)  from salesinvoicedetails where sales_id = @sales_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				cgst_total=isnull((select SUM(cgst_amt)  from salesinvoicedetails where sales_id = @sales_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				igst_total=isnull((select SUM(igst_amt)  from salesinvoicedetails where sales_id = @sales_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				discount_total=isnull((select SUM(discount_amt) from salesinvoicedetails where sales_id = @sales_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				roundoff_total=ROUND(isnull((select SUM(total_amt) from salesinvoicedetails where sales_id = @sales_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),0),
				net_total = 
							ISNULL((SELECT SUM(total_amt) 
									FROM salesinvoicedetails 
									WHERE sales_id = @sales_id 
									AND fin_year_id = @fin_year_id 
									AND comp_id = @comp_id), 0),
				balance_total =
								ISNULL((SELECT SUM(total_amt) 
										FROM salesinvoicedetails 
										WHERE sales_id = @sales_id 
										AND fin_year_id = @fin_year_id 
										AND comp_id = @comp_id), 0)
								-
								ISNULL((SELECT SUM(rd.total_amt)
											FROM receipt_details rd
											INNER JOIN receipt_mast rm 
												ON rd.receipt_id = rm.receipt_id
											WHERE rm.sales_id = @sales_id
											AND rd.fin_year_id = @fin_year_id
											AND rd.comp_id = @comp_id), 0),
				payment_status=@payment_status,
				isactive=@isactive,
				fin_year_id=@fin_year_id,
				comp_id=@comp_id,
				created_date=@created_date,
				updated_date=@updated_date,
				created_by=@created_by,
				modified_by=@modified_by
			where sales_id=@sales_id;
			
		IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sales_id and net_total>0)
		BEGIN
		IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sales_id and balance_total=0 )
		BEGIN
			Update salesinvoice_mast
			set payment_status = 1
			where sales_id = @sales_id;
		END
		ELSE IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sales_id and balance_total>0)
		BEGIN
			Update salesinvoice_mast
			set payment_status = 0
			where sales_id = @sales_id;
		END
		ELSE
		BEGIN
			Update salesinvoice_mast
			set payment_status = -1
			where sales_id = @sales_id;
		END
		END
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
		select sm.sales_id,sm.prefix,sm.suffix,cm.customer_name,sm.sales_date,sm.gross_total,sm.sgst_total,
		sm.cgst_total,sm.igst_total,sm.discount_total,sm.roundoff_total,sm.net_total,sm.balance_total,sm.payment_status,
		sm.isactive,fym.fin_name,cpm.comp_name,sm.created_date,sm.updated_date,um.user_name 
		from salesinvoice_mast sm
		left join customer_mast cm on sm.customer_id=cm.customer_id
		left join fin_year_mast fym on sm.fin_year_id=fym.fin_year_id
		left join company_mast cpm on sm.comp_id=cpm.comp_id
		left join user_mast um on sm.created_by=um.user_id;
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
		select sales_id,prefix,suffix,customer_id,sales_date,gross_total,sgst_total,cgst_total,igst_total,discount_total,roundoff_total,net_total,balance_total,payment_status,isactive,fin_year_id,comp_id,created_date,updated_date,created_by,modified_by from salesinvoice_mast where sales_id=@sales_id;
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

