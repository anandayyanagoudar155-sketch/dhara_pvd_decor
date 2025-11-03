create procedure [dbo].[sp_salesinvoicedetails_ins_upd_del](
@action varchar(max),
@sales_detail_id bigint=0,
@sales_id bigint=0,
@inward_id bigint=0,
@product_id bigint=0,
@colour_id bigint=0,
@unit_id bigint=0,
@length decimal(12,2)=0,
@width decimal(12,2)=0,
@height decimal(12,2)=0,
@kg decimal(12,2)=0,
@liters decimal(12,2)=0,
@totalsqf_runningfeet decimal(12,2)=0,
@rate decimal(12,2)=0,
@totalquantity decimal(10,2)=0,
@gross_amt decimal(12,2)=0,
@sgst_perc decimal(5,2)=0,
@sgst_amt decimal(12,2)=0,
@cgst_perc decimal(5,2)=0,
@cgst_amt decimal(12,2)=0,
@igst_perc decimal(5,2)=0,
@igst_amt decimal(12,2)=0,
@discount_perc decimal(5,2)=0,
@discount_amt decimal(12,2)=0,
@total_amt decimal(12,2)=0,
@fin_year_id bigint=0,
@comp_id bigint=0,
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
			insert into salesinvoicedetails(
			sales_id,
			inward_id,
			product_id,
			colour_id,
			unit_id,
			length,
			width,
			height,
			kg,
			liters,
			totalsqf_runningfeet,
			rate,
			totalquantity,
			gross_amt,
			sgst_perc,
			sgst_amt,
			cgst_perc,
			cgst_amt,
			igst_perc,
			igst_amt,
			discount_perc,
			discount_amt,
			total_amt,
			fin_year_id,
			comp_id,
			created_date,
			updated_date,
			user_id)
			values(@sales_id,@inward_id,@product_id,@colour_id,@unit_id,@length,@width,@height,@kg,@liters,@totalsqf_runningfeet,@rate,@totalquantity,@gross_amt,@sgst_perc,@sgst_amt,
			@cgst_perc,@cgst_amt,@igst_perc,@igst_amt,@discount_perc,@discount_amt,@total_amt,@fin_year_id,@comp_id,@created_date,@updated_date,@user_id)
		
				update salesinvoice_mast
				set 
				  gross_total = (select SUM(gross_amt) from salesinvoicedetails where sales_id = @sales_id),
				  sgst_total  = (select SUM(sgst_amt)  from salesinvoicedetails where sales_id = @sales_id),
				  cgst_total  = (select SUM(cgst_amt)  from salesinvoicedetails where sales_id = @sales_id),
				  igst_total  = (select SUM(igst_amt)  from salesinvoicedetails where sales_id = @sales_id),
				  discount_total = (select SUM(discount_amt) from salesinvoicedetails where sales_id = @sales_id),
				  net_total   = (select SUM(total_amt) from salesinvoicedetails where sales_id = @sales_id)
				where sales_id = @sales_id;
		
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
		end catch
end



if @action='delete'
begin	
	begin try
		begin transaction;
			delete from salesinvoicedetails where sales_detail_id=@sales_detail_id;

				update salesinvoice_mast
				set 
				  gross_total = (select SUM(gross_amt) from salesinvoicedetails where sales_id = @sales_id),
				  sgst_total  = (select SUM(sgst_amt)  from salesinvoicedetails where sales_id = @sales_id),
				  cgst_total  = (select SUM(cgst_amt)  from salesinvoicedetails where sales_id = @sales_id),
				  igst_total  = (select SUM(igst_amt)  from salesinvoicedetails where sales_id = @sales_id),
				  discount_total = (select SUM(discount_amt) from salesinvoicedetails where sales_id = @sales_id),
				  net_total   = (select SUM(total_amt) from salesinvoicedetails where sales_id = @sales_id)
				where sales_id = @sales_id;

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
			@ErrorMessage			
		end catch
	end
	
	

if @action='update'
begin
	begin try
		begin transaction
			update salesinvoicedetails
			set sales_id=@sales_id,
			inward_id=@inward_id,
			product_id=@product_id,
			colour_id=@colour_id,
			unit_id=@unit_id,
			length=@length,
			width=@width,
			height=@height,
			kg=@kg,
			liters=@liters,
			totalsqf_runningfeet=@totalsqf_runningfeet,
			rate=@rate,
			totalquantity=@totalquantity,
			gross_amt=@gross_amt,
			sgst_perc=@sgst_perc,
			sgst_amt=@sgst_amt,
			cgst_perc=@cgst_perc,
			cgst_amt=@cgst_amt,
			igst_perc=@igst_perc,
			igst_amt=@igst_amt,
			discount_perc=@discount_perc,
			discount_amt=@discount_amt,
			total_amt=@total_amt,
			fin_year_id=@fin_year_id,
			comp_id=@comp_id,
			created_date=@created_date,
			updated_date=@updated_date,
			user_id=@user_id
			where sales_detail_id=@sales_detail_id;

				update salesinvoice_mast
				set 
				  gross_total = (select SUM(gross_amt) from salesinvoicedetails where sales_id = @sales_id),
				  sgst_total  = (select SUM(sgst_amt)  from salesinvoicedetails where sales_id = @sales_id),
				  cgst_total  = (select SUM(cgst_amt)  from salesinvoicedetails where sales_id = @sales_id),
				  igst_total  = (select SUM(igst_amt)  from salesinvoicedetails where sales_id = @sales_id),
				  discount_total = (select SUM(discount_amt) from salesinvoicedetails where sales_id = @sales_id),
				  net_total   = (select SUM(total_amt) from salesinvoicedetails where sales_id = @sales_id)
				where sales_id = @sales_id;

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
			@ErrorMessage			
		end catch
end


if @action='selectall'
begin
	begin try
		select sales_detail_id,
		sales_id,
		inward_id,
		product_id,
		colour_id,
		unit_id,
		length,
		width,
		height,
		kg,
		liters,
		totalsqf_runningfeet,
		rate,
		totalquantity,
		gross_amt,
		sgst_perc,
		sgst_amt,
		cgst_perc,
		cgst_amt,
		igst_perc,
		igst_amt,
		discount_perc,
		discount_amt,
		total_amt,
		fin_year_id,
		comp_id,
		created_date,
		updated_date,
		user_id 
		from salesinvoicedetails 
		
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
			@ErrorMessage
		end catch
end


if @action='selectone'
begin
	begin try

		select sales_detail_id,
		sales_id,
		inward_id,
		product_id,
		colour_id,
		unit_id,
		length,
		width,
		height,
		kg,
		liters,
		totalsqf_runningfeet,
		rate,
		totalquantity,
		gross_amt,
		sgst_perc,
		sgst_amt,
		cgst_perc,
		cgst_amt,
		igst_perc,
		igst_amt,
		discount_perc,
		discount_amt,
		total_amt,
		fin_year_id,
		comp_id,
		created_date,
		updated_date,
		user_id 
		from salesinvoicedetails where sales_detail_id=@sales_detail_id;

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
		@ErrorMessage
	end catch
end



end