USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_payment_mast_ins_upd_del]    Script Date: 13-11-2025 17:06:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_payment_mast_ins_upd_del](
@action varchar(max) = '',
@payment_id bigint,
@trans_id bigint,		
@purchase_id bigint,	
@emp_payslip_id bigint,
@payment_date date,		
@net_total decimal(12,2),			
@balance_total  decimal(12,2),			
@payment_status bit,		
@created_date date,		
@updated_date  date,			
@fin_year_id bigint,	
@comp_id bigint,				
@user_id bigint	
)
as
Begin
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);
set @net_total = (Select net_total from purchaseinvoice_mast where purchase_id = @purchase_id)
	if @action = 'insert'
	set @balance_total = @net_total;
	begin
		begin try
			begin transaction
			insert into payment_mast(trans_id,purchase_id,emp_payslip_id,payment_date,net_total,
			balance_total,payment_status,created_date,updated_date,fin_year_id,comp_id,user_id)
			values(@trans_id,@purchase_id,@emp_payslip_id,@payment_date,@net_total,@balance_total,
			@payment_status,@created_date,@updated_date,@fin_year_id,@comp_id,@user_id);
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
			Select pm.payment_id,pm.trans_id,pim.purchase_id,ep.emp_payslip_id,pm.payment_date,pm.net_total,pm.balance_total,
			pm.payment_status,pm.created_date,pm.updated_date,fym.fin_name,cm.comp_name,um.user_name
			from payment_mast pm 
			left join purchaseinvoice_mast pim on pm.purchase_id = pim.purchase_id
			left join employee_payslip ep on pm.emp_payslip_id = ep.emp_payslip_id
			left join user_mast um on pm.user_id = um.user_id
			left join fin_year_mast fym on pm.fin_year_id = fym.fin_year_id
			left join company_mast cm on pm.comp_id=cm.comp_id;
			
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
			Select pm.payment_id,pm.trans_id,pm.purchase_id,pm.emp_payslip_id,pm.payment_date,pm.net_total,pm.balance_total,
			pm.payment_status,pm.created_date,pm.updated_date,pm.fin_year_id,pm.comp_id,pm.user_id
			from payment_mast pm 
			where pm.payment_id=@payment_id;
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
			
			delete from payment_mast where payment_id = @payment_id;
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
			update payment_mast
			set trans_id = @trans_id,
				purchase_id = @purchase_id,
				emp_payslip_id = @emp_payslip_id,
				payment_date = @payment_date,
				net_total = @net_total,
				balance_total = @balance_total,
				payment_status = @payment_status,
				created_date = @created_date,
				updated_date = @updated_date,
				fin_year_id = @fin_year_id,
				comp_id = @comp_id,
				user_id = @user_id
			where payment_id = @payment_id;

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

