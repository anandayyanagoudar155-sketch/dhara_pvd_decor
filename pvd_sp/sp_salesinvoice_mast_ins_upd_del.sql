USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_salesinvoice_mast_ins_upd_del]    Script Date: 13-11-2025 17:04:15 ******/
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
@user_id bigint=0
)
as
begin

declare @ErrorNumber int, @ErrorProcedure nvarchar(128), @ErrorLine int, @ErrorMessage nvarchar(max);

SET @net_total = 
    (@gross_total 
     + @sgst_total 
     + @cgst_total 
     + @igst_total)
    - @discount_total
    + @roundoff_total;

if @action='insert'
begin
set @balance_total = @net_total;
	begin try
		begin transaction
			insert into salesinvoice_mast(prefix,suffix,customer_id,sales_date,gross_total,sgst_total,cgst_total,igst_total,discount_total,roundoff_total,net_total,balance_total,payment_status,isactive,fin_year_id,comp_id,created_date,updated_date,user_id)
			values(@prefix,@suffix,@customer_id,@sales_date,@gross_total,@sgst_total,@cgst_total,@igst_total,@discount_total,@roundoff_total,@net_total,@balance_total,@payment_status,@isactive,@fin_year_id,@comp_id,@created_date,@updated_date,@user_id);
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
			update salesinvoice_mast
			set prefix=@prefix,
			suffix=@suffix,
			customer_id=@customer_id,
			sales_date=@sales_date,
			gross_total=@gross_total,
			sgst_total=@sgst_total,
			cgst_total=@cgst_total,
			igst_total=@igst_total,
			discount_total=@discount_total,
			roundoff_total=@roundoff_total,
			net_total=@net_total,
			balance_total=@balance_total,
			payment_status=@payment_status,
			isactive=@isactive,
			fin_year_id=@fin_year_id,
			comp_id=@comp_id,
			created_date=@created_date,
			updated_date=@updated_date,
			user_id=@user_id
			where sales_id=@sales_id;
			
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
		left join user_mast um on sm.user_id=um.user_id;
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
		select sales_id,prefix,suffix,customer_id,sales_date,gross_total,sgst_total,cgst_total,igst_total,discount_total,roundoff_total,net_total,balance_total,payment_status,isactive,fin_year_id,comp_id,created_date,updated_date,user_id from salesinvoice_mast where sales_id=@sales_id;
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

