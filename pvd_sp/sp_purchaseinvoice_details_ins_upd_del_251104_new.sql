USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_purchaseinvoice_details_ins_upd_del]    Script Date: 04-11-2025 17:19:20 ******/
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

	if @action = 'insert'
	begin
		begin try
			begin transaction
			insert into purchaseinvoice_details(purchase_id,product_id,colour_id,unit_id,length,width,height,
			kg,liters,totalsqf_runningfeet,rate,gross_amt,totalquantity,sgst_perc,sgst_amt,cgst_perc,cgst_amt,
			igst_perc,igst_amt,discount_perc,discount_amt,total_amt,created_date,updated_date,fin_year_id,
			comp_id,user_id)
			values(@purchase_id,@product_id,@colour_id,@unit_id,@length,@width,@height,@kg,@liters,@totalsqf_runningfeet,
			@rate,@gross_amt,@totalquantity,@sgst_perc,@sgst_amt,@cgst_perc,@cgst_amt,@igst_perc,@igst_amt,@discount_perc,
			@discount_amt,@total_amt,@created_date,@updated_date,@fin_year_id,@comp_id,@user_id);
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
			inner join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
			inner join user_mast um on pid.user_id = um.user_id
			inner join company_mast cm on pid.comp_id = cm.comp_id
			inner join fin_year_mast fym on pid.fin_year_id = fym.fin_year_id
			inner join product_mast pm on pid.product_id = pm.product_id
			inner join colour_mast crm on  pid.colour_id = crm.colour_id
			inner join unit_mast utm on pid.unit_id = utm.unit_id;
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
			Select pid.purchase_detail_id,pid.purchase_id,pm.product_name,crm.colour_name,utm.unit_name,pid.length,
			pid.width,pid.height,pid.kg,pid.liters,pid.totalsqf_runningfeet,pid.rate,pid.gross_amt,pid.totalquantity,
			pid.sgst_perc,pid.sgst_amt,pid.cgst_perc,pid.cgst_amt,pid.igst_perc,pid.igst_amt,pid.discount_perc,
			pid.discount_amt,pid.total_amt,pid.created_date,pid.updated_date,fym.fin_name,cm.comp_name,um.user_name
			from purchaseinvoice_details pid
			inner join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
			inner join user_mast um on pid.user_id = um.user_id
			inner join company_mast cm on pid.comp_id = cm.comp_id
			inner join fin_year_mast fym on pid.fin_year_id = fym.fin_year_id
			inner join product_mast pm on pid.product_id = pm.product_id
			inner join colour_mast crm on  pid.colour_id = crm.colour_id
			inner join unit_mast utm on pid.unit_id = utm.unit_id
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
			
			delete from purchaseinvoice_details where purchase_detail_id = @purchase_detail_id;
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
				updated_date = @updated_date,
				fin_year_id = @fin_year_id,
				comp_id = @comp_id,
				user_id = @user_id
			where purchase_detail_id = @purchase_detail_id;

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

