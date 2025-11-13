USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_payment_details_ins_upd_del]    Script Date: 13-11-2025 17:06:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_payment_details_ins_upd_del](
@action varchar(max) = '',
@payment_detail_id bigint,	
@payment_id bigint,				
@pay_type_id bigint,			
@total_amt decimal(12,2),		
@cheque_number varchar(20),		
@cheque_bankname varchar(100),	
@ifsc_code varchar(11),			
@cheque_date date,	
@account_number varchar(20),	
@transaction_id varchar(50),		
@card_number varchar(4),		
@transaction_date date,	
@created_date date,		
@updated_date date,		
@fin_year_id  bigint,			
@comp_id  bigint,				
@user_id bigint		
)
as
Begin
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);

declare @balance_amount decimal(12,2);
set @balance_amount = (Select sum(balance_total) from payment_mast  where payment_id = @payment_id);
if @balance_amount < @total_amt
begin
	return;
end


	if @action = 'insert'
	begin
		begin try
			begin transaction
			insert into payment_details(payment_id,pay_type_id,total_amt,cheque_number,cheque_bankname,
			ifsc_code,cheque_date,account_number,transaction_id,card_number,transaction_date,created_date,
			updated_date,fin_year_id,comp_id,user_id)
			values(@payment_id,@pay_type_id,@total_amt,@cheque_number,@cheque_bankname,@ifsc_code,@cheque_date,
			@account_number,@transaction_id,@card_number,@transaction_date,@created_date,@updated_date,
			@fin_year_id,@comp_id,@user_id);

			update payment_mast 
			set balance_total = net_total - ISNULL((Select SUM(total_amt) from payment_details pd where pd.payment_id = @payment_id),0)
			where  payment_id = @payment_id;

			update  pim
			set balance_total = pim.net_total - ISNULL((Select SUM(total_amt) from payment_details pd where pd.payment_id = @payment_id),0)
			from purchaseinvoice_mast pim
			inner join payment_mast pm on pim.purchase_id = pm.purchase_id
			inner join payment_details pd on pm.payment_id = pd.payment_id
			where  pd.payment_id = @payment_id;

			if @balance_amount = 0
			begin
				update payment_mast 
				set payment_status = 1
				where  payment_id = @payment_id;

				update purchaseinvoice_mast 
				set paymentstatus = 1
				from purchaseinvoice_mast pim
				inner join payment_mast pm on pim.purchase_id = pm.purchase_id
				inner join payment_details pd on pm.payment_id = pd.payment_id
				where  pd.payment_id = @payment_id;
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

	if @action = 'select all'
	begin
		begin try
			Select pd.payment_detail_id,pm.payment_id,pay_type_id,pd.total_amt,pd.cheque_number,pd.cheque_bankname,pd.ifsc_code,
			pd.cheque_date,pd.account_number,pd.transaction_id,pd.card_number,pd.transaction_date,pd.created_date,
			pd.updated_date,fym.fin_name,cm.comp_name,um.user_name
			from payment_details pd 
			left join payment_mast pm on pd.payment_id = pm.payment_id
			left join paytype_mast ptm on pd.pay_type_id = ptm.paytype_id
			left join user_mast um on pd.user_id = um.user_id
			left join fin_year_mast fym on pd.fin_year_id = fym.fin_year_id
			left join company_mast cm on pd.comp_id=cm.comp_id;
			
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
			Select pd.payment_detail_id,pd.payment_id,pay_type_id,pd.total_amt,pd.cheque_number,pd.cheque_bankname,pd.ifsc_code,
			pd.cheque_date,pd.account_number,pd.transaction_id,pd.card_number,pd.transaction_date,pd.created_date,
			pd.updated_date,pd.fin_year_id,pd.comp_id,pd.user_id
			from payment_details pd
			where pd.payment_detail_id=@payment_detail_id;
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
			
			delete from payment_details where payment_detail_id = @payment_detail_id;

			update payment_mast 
			set balance_total = net_total - ISNULL((Select SUM(total_amt) from payment_details pd where pd.payment_id = @payment_id),0)
			where  payment_id = @payment_id;

			update  pim
			set balance_total = pim.net_total - ISNULL((Select SUM(total_amt) from payment_details pd where pd.payment_id = @payment_id),0)
			from purchaseinvoice_mast pim
			inner join payment_mast pm on pim.purchase_id = pm.purchase_id
			inner join payment_details pd on pm.payment_id = pd.payment_id
			where  pd.payment_id = @payment_id;

			if @balance_amount = 0
			begin
				update payment_mast 
				set payment_status = 1
				where  payment_id = @payment_id;

				update purchaseinvoice_mast 
				set paymentstatus = 1
				from purchaseinvoice_mast pim
				inner join payment_mast pm on pim.purchase_id = pm.purchase_id
				inner join payment_details pd on pm.payment_id = pd.payment_id
				where  pd.payment_id = @payment_id;
			end

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
			update payment_details
			set payment_id = @payment_id,
				pay_type_id = @pay_type_id,
				total_amt = @total_amt,
				cheque_number = @cheque_number,
				cheque_bankname = @cheque_bankname,
				ifsc_code = @ifsc_code,
				cheque_date = @cheque_date,
				account_number = @account_number,
				transaction_id = @transaction_id,
				card_number = @card_number,
				transaction_date = @transaction_date,
				created_date = @created_date,
				updated_date = @updated_date,
				fin_year_id = @fin_year_id,
				comp_id = @comp_id,
				user_id = @user_id
			where payment_detail_id = @payment_detail_id;

			update payment_mast 
			set balance_total = net_total - ISNULL((Select SUM(total_amt) from payment_details pd where pd.payment_id = @payment_id),0)
			where  payment_id = @payment_id;

			update  pim
			set balance_total = pim.net_total - ISNULL((Select SUM(total_amt) from payment_details pd where pd.payment_id = @payment_id),0)
			from purchaseinvoice_mast pim
			inner join payment_mast pm on pim.purchase_id = pm.purchase_id
			inner join payment_details pd on pm.payment_id = pd.payment_id
			where  pd.payment_id = @payment_id;

			if @balance_amount = 0
			begin
				update payment_mast 
				set payment_status = 1
				where  payment_id = @payment_id;

				update purchaseinvoice_mast 
				set paymentstatus = 1
				from purchaseinvoice_mast pim
				inner join payment_mast pm on pim.purchase_id = pm.purchase_id
				inner join payment_details pd on pm.payment_id = pd.payment_id
				where  pd.payment_id = @payment_id;
			end

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

