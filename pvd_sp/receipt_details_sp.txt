create procedure sp_receipt_details_ins_upd_del(
@action varchar(max),
@receipt_dtl_id  bigint=0,
@receipt_id bigint=0,
@paytype_id bigint=0,
@total_amt decimal(12,2)=0,
@cheque_number varchar(10)='',
@cheque_bankname varchar(100)='',
@ifsc_code varchar(10)='',
@cheque_date date=null,
@account_number varchar(25)='',
@transaction_id varchar(30)='',
@card_number varchar(4)='',
@transaction_date date=null,
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
			insert into receipt_details(receipt_id,paytype_id,total_amt,cheque_number,ifsc_code,cheque_date,account_number,transaction_id,card_number,transaction_date,fin_year_id,comp_id,created_date,updated_date,user_id)
			values(@receipt_id,@paytype_id,@total_amt,@cheque_number,@ifsc_code,@cheque_date,@account_number,@transaction_id,@card_number,@transaction_date,@fin_year_id,@comp_id,@created_date,@updated_date,@user_id);
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
		
			delete from receipt_details where receipt_dtl_id=@receipt_dtl_id;
		
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
			update receipt_details 
			set receipt_id=@receipt_id,
			paytype_id=@paytype_id,
			total_amt=@total_amt,
			cheque_number=@cheque_number,
			ifsc_code=@ifsc_code,
			cheque_date=@cheque_date,
			account_number=@account_number,
			transaction_id=@transaction_id,
			card_number=@card_number,
			transaction_date=@transaction_date,
			fin_year_id=@fin_year_id,
			comp_id=@comp_id,
			created_date=@created_date,
			updated_date=@updated_date,
			user_id=@user_id
				where receipt_dtl_id=@receipt_dtl_id
				
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
		select receipt_dtl_id,receipt_id,paytype_id,total_amt,cheque_number,ifsc_code,cheque_date,account_number,transaction_id,card_number,transaction_date,fin_year_id,comp_id,created_date,updated_date,user_id from receipt_details;
		
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
		select receipt_dtl_id,receipt_id,paytype_id,total_amt,cheque_number,ifsc_code,cheque_date,account_number,transaction_id,card_number,transaction_date,fin_year_id,comp_id,created_date,updated_date,user_id from receipt_details where receipt_dtl_id=@receipt_dtl_id;
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
	
	

--if @action = 'receiptdetailslist'
--begin
--	begin try
--		select receipt_dtl_id from receipt_details
--	end try
--	begin catch
		
--		set @ErrorNumber = ERROR_NUMBER();
--		set @ErrorProcedure = ERROR_PROCEDURE();
--		set @ErrorLine = ERROR_LINE();
--		set @ErrorMessage = ERROR_MESSAGE();

--		exec errorlog_ins
--		@ErrorNumber,
--		@ErrorProcedure,
--		@ErrorLine,
--		@ErrorMessage			
--	end catch
--end


end