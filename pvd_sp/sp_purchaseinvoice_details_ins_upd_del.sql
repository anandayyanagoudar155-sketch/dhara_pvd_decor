USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_purchaseinvoice_details_ins_upd_del]    Script Date: 03-12-2025 17:41:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










CREATE procedure [dbo].[sp_purchaseinvoice_details_ins_upd_del](
@action varchar(max) = '',
@purchase_detail_id bigint = 0,		
@purchase_id bigint = 0,
@product_id bigint = 0,
@colour_id bigint = 0,
@unit_id bigint = 0,
@length decimal(12,2) = 0,
@width decimal(12,2) = 0,
@height decimal(12,2) = 0,
@kg decimal(12,2) = 0,
@liters decimal(12,2) = 0,
@totalsqf_runningfeet decimal(12,2) = 0,
@rate decimal(12,2) = 0,  					
@gross_amt decimal(12,2) = 0,
@totalquantity decimal(10,2) = 0,
@sgst_perc decimal(5,2) = 0,
@sgst_amt decimal(12,2) = 0,
@cgst_perc decimal(5,2) = 0,
@cgst_amt decimal(12,2) = 0,
@igst_perc decimal(5,2) = 0,
@igst_amt decimal(12,2) = 0,
@discount_perc decimal(5,2) = 0,
@discount_amt decimal(12,2) = 0,
@total_amt decimal(12,2) = 0,
@created_date date = null,
@updated_date date = null,
@fin_year_id bigint = 0,
@comp_id bigint = 0,
@user_id bigint = 0
)
as
Begin
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);
declare @sid bigint;
declare @pid bigint;
declare @cid bigint;
declare @fid bigint;
declare @vendor_id bigint;
set @rate = isnull((Select rate from product_mast  where product_id = @product_id),0);
set @sgst_perc =isnull((Select hm.sgst_perc from product_mast pm 
				inner join hsn_mast hm on pm.hsn_id = hm.hsn_id
				where pm.product_id = @product_id),0);
set @cgst_perc =isnull((Select hm.cgst_perc from product_mast pm 
				inner join hsn_mast hm on pm.hsn_id = hm.hsn_id
				where pm.product_id = @product_id),0);
set @igst_perc =isnull((Select hm.igst_perc from product_mast pm 
				inner join hsn_mast hm on pm.hsn_id = hm.hsn_id
				where pm.product_id = @product_id),0);
set @gross_amt =isnull((@rate * @totalquantity * @totalsqf_runningfeet),0);
set @sgst_amt = isnull(((@gross_amt * @sgst_perc)/100),0);
set @cgst_amt = isnull(((@gross_amt * @cgst_perc)/100),0);
set @igst_amt = isnull(((@gross_amt * @igst_perc)/100),0);
set @discount_amt = isnull(((@gross_amt * @discount_perc)/100),0);
set @total_amt = isnull(((@gross_amt + @sgst_amt + @cgst_amt + @igst_amt) - @discount_amt),0);

	if @action = 'insert'
	begin
		begin try
			begin transaction
			if not EXISTS (Select 1 from colour_mast where colour_id = @colour_id)
			Begin
					RAISERROR('Cannot insert: colour_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from unit_mast where unit_id = @unit_id)
			Begin
					RAISERROR('Cannot insert: unit_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from purchaseinvoice_mast where purchase_id = @purchase_id)
			Begin
					RAISERROR('Cannot insert: purchase_id is incorrect', 16, 1);
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
			if not EXISTS (Select 1 from user_mast where user_id = @user_id)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End

			
			insert into purchaseinvoice_details(purchase_id,product_id,colour_id,unit_id,length,width,height,
			kg,liters,totalsqf_runningfeet,rate,gross_amt,totalquantity,sgst_perc,sgst_amt,cgst_perc,cgst_amt,
			igst_perc,igst_amt,discount_perc,discount_amt,total_amt,created_date,updated_date,fin_year_id,
			comp_id,user_id)
			values(@purchase_id,@product_id,@colour_id,@unit_id,@length,@width,@height,@kg,@liters,@totalsqf_runningfeet,
			@rate,@gross_amt,@totalquantity,@sgst_perc,@sgst_amt,@cgst_perc,@cgst_amt,@igst_perc,@igst_amt,@discount_perc,
			@discount_amt,@total_amt,@created_date,@updated_date,@fin_year_id,@comp_id,@user_id);

			set @vendor_id = isnull((Select distinct vendor_id from purchaseinvoice_details pid 
								inner join purchaseinvoice_mast pim on pid.purchase_id=pim.purchase_id
								where pim.purchase_id=@purchase_id),0);
				

			update pim
			set  gross_total = isnull((select SUM(gross_amt) from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				  sgst_total  = isnull((select SUM(sgst_amt)  from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				  cgst_total  = isnull((select SUM(cgst_amt)  from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				  igst_total  = isnull((select SUM(igst_amt)  from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				  discount_total = isnull((select SUM(discount_amt) from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				  roundoff_total=ROUND(isnull((select SUM(total_amt) from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),0),
				  net_total   = isnull((select SUM(total_amt) from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0) ,
				  balance_total=(
										isnull((select SUM(total_amt) 
										from purchaseinvoice_details pid
										inner join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
										where pid.purchase_id=@purchase_id and pid.fin_year_id=@fin_year_id and
										pid.comp_id=@comp_id),0) 
									) - 
									( 
										isnull((
										  Select sum(pd.total_amount) as reduced_amt
										  from payment_details pd
										  inner join payment_mast pm on pd.payment_id = pm.payment_id
										  where pm.purchase_id=@purchase_id and pd.fin_year_id=@fin_year_id and 
										 pd.comp_id=@comp_id ),0)
									 )
				from purchaseinvoice_mast pim
				where pim.purchase_id=@purchase_id;

			
			     
				 update vendor_details
					set Invoice_balance = (
												isnull((select SUM(total_amt) 
												from purchaseinvoice_details pid
												inner join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
												where pim.vendor_id=@vendor_id and pim.fin_year_id=@fin_year_id and
												pim.comp_id=@comp_id),0) 
											) - 
											( 
												isnull((
												  Select sum(pd.total_amount) as reduced_amt
												  from payment_details pd
												  inner join payment_mast pm on pd.payment_id = pm.payment_id
												  inner join purchaseinvoice_mast pim on pm.purchase_id=pim.purchase_id
												  where pim.vendor_id=@vendor_id and pd.fin_year_id=@fin_year_id and 
												 pd.comp_id=@comp_id ),0)
											 ),
						Outstanding_balance = opening_balance + (
											(
												isnull((select SUM(total_amt) 
												from purchaseinvoice_details pid
												inner join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
												where pim.vendor_id=@vendor_id and pim.fin_year_id=@fin_year_id and
												pim.comp_id=@comp_id),0) 
											) - 
											( 
												isnull((
												  Select sum(pd.total_amount) as reduced_amt
												  from payment_details pd
												  inner join payment_mast pm on pd.payment_id = pm.payment_id
												  inner join purchaseinvoice_mast pim on pm.purchase_id=pim.purchase_id
												  where pim.vendor_id=@vendor_id and pd.fin_year_id=@fin_year_id and 
												 pd.comp_id=@comp_id ),0)
											 )
										 )
					where vendor_id=@vendor_id and fin_year_id=@fin_year_id and comp_id=@comp_id;

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

	if @action = 'select all'
	begin
		begin try
			Select pid.purchase_detail_id,pid.purchase_id,pm.product_name,crm.colour_name,utm.unit_name,pid.length,
			pid.width,pid.height,pid.kg,pid.liters,pid.totalsqf_runningfeet,pid.rate,pid.gross_amt,pid.totalquantity,
			pid.sgst_perc,pid.sgst_amt,pid.cgst_perc,pid.cgst_amt,pid.igst_perc,pid.igst_amt,pid.discount_perc,
			pid.discount_amt,pid.total_amt,pid.created_date,pid.updated_date,fym.fin_name,cm.comp_name,um.user_name
			from purchaseinvoice_details pid
			left join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
			left join user_mast um on pid.user_id = um.user_id
			left join company_mast cm on pid.comp_id = cm.comp_id
			left join fin_year_mast fym on pid.fin_year_id = fym.fin_year_id
			left join product_mast pm on pid.product_id = pm.product_id
			left join colour_mast crm on  pid.colour_id = crm.colour_id
			left join unit_mast utm on pid.unit_id = utm.unit_id;

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
			Select pid.purchase_detail_id,pid.purchase_id,pid.product_id,pid.colour_id,pid.unit_id,pid.length,
			pid.width,pid.height,pid.kg,pid.liters,pid.totalsqf_runningfeet,pid.rate,pid.gross_amt,pid.totalquantity,
			pid.sgst_perc,pid.sgst_amt,pid.cgst_perc,pid.cgst_amt,pid.igst_perc,pid.igst_amt,pid.discount_perc,
			pid.discount_amt,pid.total_amt,pid.created_date,pid.updated_date,pid.fin_year_id,pid.comp_id,pid.user_id
			from purchaseinvoice_details pid
			where pid.purchase_detail_id=@purchase_detail_id;
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
		begin try
			begin transaction;
			
			set @pid = isnull((select distinct purchase_id from purchaseinvoice_details where purchase_detail_id = @purchase_detail_id),0);
			set @fid = isnull((select distinct fin_year_id from purchaseinvoice_details where purchase_detail_id = @purchase_detail_id),0);
			set @cid = isnull((select distinct comp_id from purchaseinvoice_details where purchase_detail_id = @purchase_detail_id),0);

			set @vendor_id = isnull((Select distinct vendor_id from purchaseinvoice_details pid 
									inner join purchaseinvoice_mast pim on pid.purchase_id=pim.purchase_id
									where pim.purchase_id=@pid),0);


			delete from purchaseinvoice_details where purchase_detail_id = @purchase_detail_id;

			update pim
			set gross_total = isnull((select SUM(gross_amt) from purchaseinvoice_details where purchase_id=@pid and fin_year_id=@fid and comp_id=@cid),0),
				  sgst_total  = isnull((select SUM(sgst_amt)  from purchaseinvoice_details where purchase_id=@pid and fin_year_id=@fid and comp_id=@cid),0),
				  cgst_total  = isnull((select SUM(cgst_amt)  from purchaseinvoice_details where purchase_id=@pid and fin_year_id=@fid and comp_id=@cid),0),
				  igst_total  = isnull((select SUM(igst_amt)  from purchaseinvoice_details where purchase_id=@pid and fin_year_id=@fid and comp_id=@cid),0),
				  discount_total = isnull((select SUM(discount_amt) from purchaseinvoice_details where purchase_id=@pid and fin_year_id=@fid and comp_id=@cid),0),
				  roundoff_total=ROUND(isnull((select SUM(total_amt) from purchaseinvoice_details where purchase_id=@pid and fin_year_id=@fid and comp_id=@cid),0),0),
				  net_total   = isnull((select SUM(total_amt) from purchaseinvoice_details where purchase_id=@pid and fin_year_id=@fid and comp_id=@cid),0),
				  balance_total=(
										isnull((select SUM(total_amt) 
										from purchaseinvoice_details pid
										inner join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
										where pid.purchase_id=@pid and pid.fin_year_id=@fid and
										pid.comp_id=@cid),0) 
									) - 
									( 
										isnull((
										  Select sum(pd.total_amount) as reduced_amt
										  from payment_details pd
										  inner join payment_mast pm on pd.payment_id = pm.payment_id
										  where pm.payment_id=@pid and pd.fin_year_id=@fid and 
										pd.comp_id=@cid),0)
									 )
			from purchaseinvoice_mast pim
			where pim.purchase_id=@pid;

			update vendor_details
				set Invoice_balance = (
											isnull((select SUM(total_amt) 
											from purchaseinvoice_details pid
											inner join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
											where pim.vendor_id=@vendor_id and pim.fin_year_id=@fid and
											pim.comp_id=@cid),0) 
										) - 
										( 
											isnull((
											  Select sum(pd.total_amount) as reduced_amt
											  from payment_details pd
											  inner join payment_mast pm on pd.payment_id = pm.payment_id
											  inner join purchaseinvoice_mast pim on pm.purchase_id=pim.purchase_id
											  where pim.vendor_id=@vendor_id and pd.fin_year_id=@fid and 
											 pd.comp_id=@cid ),0)
										 ),
					Outstanding_balance = opening_balance + (
										(
											isnull((select SUM(total_amt) 
											from purchaseinvoice_details pid
											inner join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
											where pim.vendor_id=@vendor_id and pim.fin_year_id=@fid and
											pim.comp_id=@cid),0) 
										) - 
										( 
											isnull((
											  Select sum(pd.total_amount) as reduced_amt
											  from payment_details pd
											  inner join payment_mast pm on pd.payment_id = pm.payment_id
											  inner join purchaseinvoice_mast pim on pm.purchase_id=pim.purchase_id
											  where pim.vendor_id=@vendor_id and pd.fin_year_id=@fid and 
											 pd.comp_id=@cid ),0)
										 )
						             )
				where vendor_id=@vendor_id and fin_year_id=@fid and comp_id=@cid;
			

			IF EXISTS (SELECT 1 FROM purchaseinvoice_mast WHERE purchase_id = @pid and net_total>0)
			BEGIN
			IF EXISTS (SELECT 1 FROM purchaseinvoice_mast WHERE purchase_id = @pid and balance_total=0 )
			BEGIN
				Update purchaseinvoice_mast
				set paymentstatus = 1
				where purchase_id = @pid;
			END
			ELSE IF EXISTS (SELECT 1 FROM purchaseinvoice_mast WHERE purchase_id = @pid and balance_total>0)
			BEGIN
				Update purchaseinvoice_mast
				set paymentstatus = 0
				where purchase_id = @pid;
			END
			ELSE
			BEGIN
				Update purchaseinvoice_mast
				set paymentstatus = -1
				where purchase_id = @pid;
			END
			END

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

			if not EXISTS (Select 1 from colour_mast where colour_id = @colour_id)
			Begin
					RAISERROR('Cannot insert: colour_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from unit_mast where unit_id = @unit_id)
			Begin
					RAISERROR('Cannot insert: unit_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from purchaseinvoice_mast where purchase_id = @purchase_id)
			Begin
					RAISERROR('Cannot insert: purchase_id is incorrect', 16, 1);
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
			if not EXISTS (Select 1 from user_mast where user_id = @user_id)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End

			set @product_id = isnull((Select distinct product_id from purchaseinvoice_details 
							where purchase_detail_id = @purchase_detail_id 
						  ),0);

			

			update purchaseinvoice_details
			set purchase_id = @purchase_id,
				product_id = @product_id,
				colour_id  = @colour_id,
				unit_id = @unit_id,
				length =@length,
				width = @width,
				height = @height,
				kg = @kg,
				liters = @liters,
				totalsqf_runningfeet = @totalsqf_runningfeet,
				rate = @rate,  					
				gross_amt = @gross_amt,
				totalquantity = @totalquantity,
				sgst_perc = @sgst_perc,
				sgst_amt = @sgst_amt,
				cgst_perc = @cgst_perc,
				cgst_amt = @cgst_amt,
				igst_perc = @igst_perc,
				igst_amt = @igst_amt,
				discount_perc = @discount_perc,
				discount_amt = @discount_amt,
				total_amt = @total_amt,
				created_date = @created_date,
				updated_date = @updated_date,
				fin_year_id = @fin_year_id,
				comp_id = @comp_id,
				user_id = @user_id
			where purchase_detail_id = @purchase_detail_id;

			set @vendor_id = isnull((Select distinct vendor_id from purchaseinvoice_details pid 
								inner join purchaseinvoice_mast pim on pid.purchase_id=pim.purchase_id
								where pim.purchase_id=@purchase_id),0);

			update pim
			set  gross_total = isnull((select SUM(gross_amt) from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				  sgst_total  = isnull((select SUM(sgst_amt)  from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				  cgst_total  = isnull((select SUM(cgst_amt)  from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				  igst_total  = isnull((select SUM(igst_amt)  from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				  discount_total = isnull((select SUM(discount_amt) from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),
				  roundoff_total=ROUND(isnull((select SUM(total_amt) from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0),0),
				  net_total   = isnull((select SUM(total_amt) from purchaseinvoice_details where purchase_id=@purchase_id and fin_year_id=@fin_year_id and comp_id=@comp_id),0) ,
				  balance_total=(
										isnull((select SUM(total_amt) 
										from purchaseinvoice_details pid
										inner join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
										where pid.purchase_id=@purchase_id and pid.fin_year_id=@fin_year_id and
										pid.comp_id=@comp_id),0) 
									) - 
									( 
										isnull((
										  Select sum(pd.total_amount) as reduced_amt
										  from payment_details pd
										  inner join payment_mast pm on pd.payment_id = pm.payment_id
										  where pm.purchase_id=@purchase_id and pd.fin_year_id=@fin_year_id and 
										 pd.comp_id=@comp_id ),0)
									 )
				from purchaseinvoice_mast pim
				where pim.purchase_id=@purchase_id;

			
			     
				 update vendor_details
					set Invoice_balance = (
												isnull((select SUM(total_amt) 
												from purchaseinvoice_details pid
												inner join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
												where pim.vendor_id=@vendor_id and pim.fin_year_id=@fin_year_id and
												pim.comp_id=@comp_id),0) 
											) - 
											( 
												isnull((
												  Select sum(pd.total_amount) as reduced_amt
												  from payment_details pd
												  inner join payment_mast pm on pd.payment_id = pm.payment_id
												  inner join purchaseinvoice_mast pim on pm.purchase_id=pim.purchase_id
												  where pim.vendor_id=@vendor_id and pd.fin_year_id=@fin_year_id and 
												 pd.comp_id=@comp_id ),0)
											 ),
						Outstanding_balance = opening_balance + (
											(
												isnull((select SUM(total_amt) 
												from purchaseinvoice_details pid
												inner join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
												where pim.vendor_id=@vendor_id and pim.fin_year_id=@fin_year_id and
												pim.comp_id=@comp_id),0) 
											) - 
											( 
												isnull((
												  Select sum(pd.total_amount) as reduced_amt
												  from payment_details pd
												  inner join payment_mast pm on pd.payment_id = pm.payment_id
												  inner join purchaseinvoice_mast pim on pm.purchase_id=pim.purchase_id
												  where pim.vendor_id=@vendor_id and pd.fin_year_id=@fin_year_id and 
												 pd.comp_id=@comp_id ),0)
											 )
										 )
					where vendor_id=@vendor_id and fin_year_id=@fin_year_id and comp_id=@comp_id;

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

