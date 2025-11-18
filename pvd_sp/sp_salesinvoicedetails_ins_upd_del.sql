USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_salesinvoicedetails_ins_upd_del]    Script Date: 18-11-2025 22:13:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE procedure [dbo].[sp_salesinvoicedetails_ins_upd_del](
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
declare @sid bigint;
set @rate = isnull((Select rate from product_mast  where product_id = @product_id),0);
--set @totalquantity = (Select balance_quantity from inward_mast where inward_id = @inward_id);
set @sgst_perc =isnull((Select hm.sgst_perc from product_mast pm 
				inner join hsn_mast hm on pm.hsn_id = hm.hsn_id
				where pm.product_id = @product_id),0);
set @cgst_perc =isnull((Select hm.cgst_perc from product_mast pm 
				inner join hsn_mast hm on pm.hsn_id = hm.hsn_id
				where pm.product_id = @product_id),0);
set @igst_perc =isnull((Select hm.igst_perc from product_mast pm 
				inner join hsn_mast hm on pm.hsn_id = hm.hsn_id
				where pm.product_id = @product_id),0);
set @gross_amt =isnull((@rate * @totalquantity),0);
set @sgst_amt = isnull(((@gross_amt * @sgst_perc)/100),0);
set @cgst_amt = isnull(((@gross_amt * @cgst_perc)/100),0);
set @igst_amt = isnull(((@gross_amt * @igst_perc)/100),0);
set @discount_amt = isnull(((@gross_amt * @discount_perc)/100),0);
set @total_amt = isnull(((@gross_amt + @sgst_amt + @cgst_amt + @igst_amt) - @discount_amt),0);


if @action='insert'
begin
	begin try
		begin transaction

		if ((@totalquantity > (Select balance_quantity from inward_mast where inward_id = @inward_id and product_id = @Product_id)) or 
		((Select balance_quantity from inward_mast where inward_id = @inward_id and product_id = @Product_id) <= 0))
		Begin
			--print 'in1'
			rollback transaction;
			return;
			
		End

		
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
				  gross_total = isnull((select SUM(gross_amt) from salesinvoicedetails where sales_id = @sales_id),0),
				  sgst_total  = isnull((select SUM(sgst_amt)  from salesinvoicedetails where sales_id = @sales_id),0),
				  cgst_total  = isnull((select SUM(cgst_amt)  from salesinvoicedetails where sales_id = @sales_id),0),
				  igst_total  = isnull((select SUM(igst_amt)  from salesinvoicedetails where sales_id = @sales_id),0),
				  discount_total = isnull((select SUM(discount_amt) from salesinvoicedetails where sales_id = @sales_id),0),
				  roundoff_total=ROUND(isnull((select SUM(total_amt) from salesinvoicedetails where sales_id = @sales_id),0),0),
				  net_total   = isnull((select SUM(total_amt) from salesinvoicedetails where sales_id = @sales_id),0),
				  balance_total=(
									isnull((Select sum(total_amt) as net_toatal
									  from salesinvoicedetails
									  where sales_id = @sales_id								
									 ),0) - 
									 isnull((
									  Select sum(rd.total_amt) as reduced_amt
									  from receipt_details rd
									  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
									  where sales_id = @sales_id
									 ),0)
						  )
				where sales_id = @sales_id;

				IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sales_id and net_total>0)
				BEGIN
				IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sales_id and balance_total=0 )
				BEGIN
				--print 'In';
					Update salesinvoice_mast
					set payment_status = 1
					where sales_id = @sales_id;
				END
				ELSE IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sales_id and balance_total>0)
				BEGIN
				--print 'In1';
					Update salesinvoice_mast
					set payment_status = 0
					where sales_id = @sales_id;
				END
				ELSE
				BEGIN
				--print 'In2';
					Update salesinvoice_mast
					set payment_status = -1
					where sales_id = @sales_id;
				END
				END

				
		
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
	begin try
		begin transaction;
			
				select @sid = sales_id from salesinvoicedetails where sales_detail_id = @sales_detail_id;

				delete from salesinvoicedetails where sales_detail_id=@sales_detail_id;

				
				update salesinvoice_mast
				set 
				  gross_total = isnull((select SUM(gross_amt) from salesinvoicedetails where sales_id = @sid),0),
				  sgst_total  = isnull((select SUM(sgst_amt)  from salesinvoicedetails where sales_id = @sid),0),
				  cgst_total  = isnull((select SUM(cgst_amt)  from salesinvoicedetails where sales_id = @sid),0),
				  igst_total  = isnull((select SUM(igst_amt)  from salesinvoicedetails where sales_id = @sid),0),
				  discount_total = isnull((select SUM(discount_amt) from salesinvoicedetails where sales_id = @sid),0),
				  roundoff_total=ROUND(isnull((select SUM(total_amt) from salesinvoicedetails where sales_id = @sid),0),0),
				  net_total   = isnull((select SUM(total_amt) from salesinvoicedetails where sales_id = @sid),0),
				  balance_total=(
									isnull((Select sum(total_amt) as net_toatal
									  from salesinvoicedetails
									  where sales_id = @sid								
									 ),0) - 
									 isnull((
									  Select sum(rd.total_amt) as reduced_amt
									  from receipt_details rd
									  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
									  where sales_id = @sid
									 ),0)
						  )
				where sales_id = @sid;

				IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sid and net_total>0)
				BEGIN
				IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sid and balance_total=0 )
				BEGIN
				--print 'In';
					Update salesinvoice_mast
					set payment_status = 1
					where sales_id = @sid;
				END
				ELSE IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sid and balance_total>0)
				BEGIN
				--print 'In1';
					Update salesinvoice_mast
					set payment_status = 0
					where sales_id = @sid;
				END
				ELSE
				BEGIN
				--print 'In2';
					Update salesinvoice_mast
					set payment_status = -1
					where sales_id = @sid;
				END
				END

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

		DECLARE @balQty numeric(18,2);
		set @inward_id = (Select inward_id from salesinvoicedetails where sales_detail_id = @sales_detail_id)
		set @product_id = (Select product_id from salesinvoicedetails where sales_detail_id = @sales_detail_id)


			SELECT @balQty = balance_quantity
			FROM inward_mast 
			WHERE inward_id = @inward_id AND product_id = @product_id;

			IF (@balQty IS NULL OR @balQty <= 0 OR @totalquantity > @balQty)
			BEGIN
				--PRINT 'in1';
				ROLLBACK TRANSACTION;  -- rollback first
				RETURN;                -- exit after rollback
			END;

		
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

			select @sid = sales_id from salesinvoicedetails where sales_detail_id = @sales_detail_id;


			update salesinvoice_mast
				set 
				  gross_total = isnull((select SUM(gross_amt) from salesinvoicedetails where sales_id = @sid),0),
				  sgst_total  = isnull((select SUM(sgst_amt)  from salesinvoicedetails where sales_id = @sid),0),
				  cgst_total  = isnull((select SUM(cgst_amt)  from salesinvoicedetails where sales_id = @sid),0),
				  igst_total  = isnull((select SUM(igst_amt)  from salesinvoicedetails where sales_id = @sid),0),
				  discount_total = isnull((select SUM(discount_amt) from salesinvoicedetails where sales_id = @sid),0),
				  roundoff_total=ROUND(isnull((select SUM(total_amt) from salesinvoicedetails where sales_id = @sid),0),0),
				  net_total   = isnull((select SUM(total_amt) from salesinvoicedetails where sales_id = @sid),0),
				  balance_total=(
									isnull((Select sum(total_amt) as net_toatal
									  from salesinvoicedetails
									  where sales_id = @sid								
									 ),0) - 
									 isnull((
									  Select sum(rd.total_amt) as reduced_amt
									  from receipt_details rd
									  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
									  where sales_id = @sid
									 ),0)
						  )
				where sales_id = @sid;

				IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sid and net_total>0)
				BEGIN
				IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sid and balance_total=0 )
				BEGIN
				--print 'In';
					Update salesinvoice_mast
					set payment_status = 1
					where sales_id = @sid;
				END
				ELSE IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sid and balance_total>0)
				BEGIN
				--print 'In1';
					Update salesinvoice_mast
					set payment_status = 0
					where sales_id = @sid;
				END
				ELSE
				BEGIN
				--print 'In2';
					Update salesinvoice_mast
					set payment_status = -1
					where sales_id = @sid;
				END
				END

				

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
		select sid1.sales_detail_id,
		sim.sales_id,
		im.inward_id,
		pm.product_name,
		cm.colour_name,
		um.unit_name,
		sid1.length,
		sid1.width,
		sid1.height,
		sid1.kg,
		sid1.liters,
		sid1.totalsqf_runningfeet,
		sid1.rate,
		sid1.totalquantity,
		sid1.gross_amt,
		sid1.sgst_perc,
		sid1.sgst_amt,
		sid1.cgst_perc,
		sid1.cgst_amt,
		sid1.igst_perc,
		sid1.igst_amt,
		sid1.discount_perc,
		sid1.discount_amt,
		sid1.total_amt,
		fym.fin_name,
		cpm.comp_name,
		sid1.created_date,
		sid1.updated_date,
		usm.user_name 
		from salesinvoicedetails sid1
		left join salesinvoice_mast sim on sid1.sales_id=sim.sales_id
		left join inward_mast im on sid1.inward_id = im.inward_id
		left join product_mast pm on sid1.product_id = pm.product_id
		left join colour_mast cm on sid1.colour_id=cm.colour_id
		left join unit_mast um on sid1.unit_id=um.unit_id
		left join fin_year_mast fym on sid1.fin_year_id=fym.fin_year_id
		left join company_mast  cpm on sid1.comp_id=cpm.comp_id
		left join user_mast usm on sid1.user_id=usm.user_id;
		
		
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
		@ErrorMessage;

		THROW;
	end catch
end



end
GO

