USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_receipt_details_ins_upd_del]    Script Date: 18-11-2025 22:22:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE procedure [dbo].[sp_receipt_details_ins_upd_del](
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

declare @balance_amount decimal(12,2);
declare @sim_id bigint;
declare @rd_id bigint;



if @action='insert'
begin
	begin try
		begin transaction

		set @balance_amount = (Select sum(balance_amount) from receipt_mast  where receipt_id = @receipt_id)
		if @balance_amount < @total_amt
		begin
		rollback transaction;
			return;
		end



			insert into receipt_details(receipt_id,paytype_id,total_amt,cheque_number,ifsc_code,cheque_date,account_number,transaction_id,card_number,transaction_date,fin_year_id,comp_id,created_date,updated_date,user_id)
			values(@receipt_id,@paytype_id,@total_amt,@cheque_number,@ifsc_code,@cheque_date,@account_number,@transaction_id,@card_number,@transaction_date,@fin_year_id,@comp_id,@created_date,@updated_date,@user_id);

			

			Update receipt_mast
			set balance_amount = isnull((Select sum(total_amt) as net_toatal
								  from salesinvoicedetails sid
								  inner join receipt_mast rm on sid.sales_id = rm.sales_id
								  where receipt_id = @receipt_id								
								 ),0) - 
								 isnull((
								  Select sum(total_amt) as reduced_amt
								  from receipt_details rd
								  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
								  where rd.receipt_id = @receipt_id
								 ),0)
			where receipt_id = @receipt_id;

			Update sim
			set balance_total = isnull((Select sum(total_amt) as net_toatal
							  from salesinvoicedetails sid
							  inner join receipt_mast rm on sid.sales_id = rm.sales_id
							  where receipt_id = @receipt_id								
							 ),0) - 
							 isnull((
							  Select sum(total_amt) as reduced_amt
							  from receipt_details rd
							  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
							  where rd.receipt_id = @receipt_id
							 ),0)
			from salesinvoice_mast sim
			inner join receipt_mast rm on sim.sales_id = rm.sales_id
			inner join receipt_details rd on rm.receipt_id = rd.receipt_id
			where  rd.receipt_id = @receipt_id;

			

			IF EXISTS (SELECT 1 FROM receipt_mast WHERE receipt_id = @receipt_id and net_total>0)
			BEGIN
			IF EXISTS (SELECT 1 FROM receipt_mast WHERE receipt_id = @receipt_id and balance_amount=0 )
			BEGIN
			--print 'In';
				Update receipt_mast
				set receipt_status = 1
				where receipt_id = @receipt_id
			END
			ELSE IF EXISTS (SELECT 1 FROM receipt_mast WHERE receipt_id = @receipt_id and balance_amount>0)
			BEGIN
			--print 'In1';
				Update receipt_mast
				set receipt_status = 0
				where receipt_id = @receipt_id
			END
			ELSE
			BEGIN
			--print 'In2';
				Update receipt_mast
				set receipt_status = -1
				where receipt_id = @receipt_id
			END
			END


			set @sim_id = (Select sales_id from receipt_mast  where receipt_id = @receipt_id);

			IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sim_id and net_total>0)
			BEGIN
			IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sim_id and balance_total=0 )
			BEGIN
			--print 'In';
				Update salesinvoice_mast
				set payment_status = 1
				where sales_id = @sim_id;
			END
			ELSE IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sim_id and balance_total>0)
			BEGIN
			--print 'In1';
				Update salesinvoice_mast
				set payment_status = 0
				where sales_id = @sim_id;
			END
			ELSE
			BEGIN
			--print 'In2';
				Update salesinvoice_mast
				set payment_status = -1
				where sales_id = @sim_id;
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
		
			set @rd_id = (Select receipt_id from receipt_details where receipt_dtl_id = @receipt_dtl_id);
			delete from receipt_details where receipt_dtl_id=@receipt_dtl_id;
		
			
			Update receipt_mast
			set balance_amount = isnull((Select sum(total_amt) as net_toatal
								  from salesinvoicedetails sid
								  inner join receipt_mast rm on sid.sales_id = rm.sales_id
								  where receipt_id = @rd_id								
								 ),0) - 
								 isnull((
								  Select sum(total_amt) as reduced_amt
								  from receipt_details rd
								  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
								  where rd.receipt_id = @rd_id
								 ),0)
			where receipt_id = @rd_id;

			Update sim
			set balance_total = isnull((Select sum(total_amt) as net_toatal
							  from salesinvoicedetails sid
							  inner join receipt_mast rm on sid.sales_id = rm.sales_id
							  where receipt_id = @rd_id								
							 ),0) - 
							 isnull((
							  Select sum(total_amt) as reduced_amt
							  from receipt_details rd
							  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
							  where rd.receipt_id = @rd_id
							 ),0)
			from salesinvoice_mast sim
			inner join receipt_mast rm on sim.sales_id = rm.sales_id
			inner join receipt_details rd on rm.receipt_id = rd.receipt_id
			where  rd.receipt_id = @rd_id;

			IF EXISTS (SELECT 1 FROM receipt_mast WHERE receipt_id = @rd_id and net_total>0)
			BEGIN
			IF EXISTS (SELECT 1 FROM receipt_mast WHERE receipt_id = @rd_id and balance_amount=0 )
			BEGIN
			--print 'In';
				Update receipt_mast
				set receipt_status = 1
				where receipt_id = @rd_id
			END
			ELSE IF EXISTS (SELECT 1 FROM receipt_mast WHERE receipt_id = @rd_id and balance_amount>0)
			BEGIN
			--print 'In1';
				Update receipt_mast
				set receipt_status = 0
				where receipt_id = @rd_id
			END
			ELSE
			BEGIN
			--print 'In2';
				Update receipt_mast
				set receipt_status = -1
				where receipt_id = @rd_id
			END
			END


			
			set @sim_id = (Select sales_id from receipt_mast  where receipt_id = @rd_id);

			IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sim_id and net_total>0)
			BEGIN
			IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sim_id and balance_total=0 )
			BEGIN
			--print 'In';
				Update salesinvoice_mast
				set payment_status = 1
				where sales_id = @sim_id;
			END
			ELSE IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sim_id and balance_total>0)
			BEGIN
			--print 'In1';
				Update salesinvoice_mast
				set payment_status = 0
				where sales_id = @sim_id;
			END
			ELSE
			BEGIN
			--print 'In2';
				Update salesinvoice_mast
				set payment_status = -1
				where sales_id = @sim_id;
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

			set @rd_id = (Select receipt_id from receipt_details where receipt_dtl_id = @receipt_dtl_id);

			set @balance_amount = (Select sum(balance_amount) from receipt_mast  where receipt_id = @rd_id);
			if @balance_amount < @total_amt
			begin
			rollback transaction;
				return;
			end

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
			where receipt_dtl_id=@receipt_dtl_id;

			Update receipt_mast
			set balance_amount = isnull((Select sum(total_amt) as net_toatal
								  from salesinvoicedetails sid
								  inner join receipt_mast rm on sid.sales_id = rm.sales_id
								  where receipt_id = @rd_id								
								 ),0) - 
								 isnull((
								  Select sum(total_amt) as reduced_amt
								  from receipt_details rd
								  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
								  where rd.receipt_id = @rd_id
								 ),0)
			where receipt_id = @rd_id;

			Update sim
			set balance_total = isnull((Select sum(total_amt) as net_toatal
							  from salesinvoicedetails sid
							  inner join receipt_mast rm on sid.sales_id = rm.sales_id
							  where receipt_id = @rd_id								
							 ),0) - 
							 isnull((
							  Select sum(total_amt) as reduced_amt
							  from receipt_details rd
							  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
							  where rd.receipt_id = @rd_id
							 ),0)
			from salesinvoice_mast sim
			inner join receipt_mast rm on sim.sales_id = rm.sales_id
			inner join receipt_details rd on rm.receipt_id = rd.receipt_id
			where  rd.receipt_id = @rd_id;

			IF EXISTS (SELECT 1 FROM receipt_mast WHERE receipt_id = @rd_id and net_total>0)
			BEGIN
			IF EXISTS (SELECT 1 FROM receipt_mast WHERE receipt_id = @rd_id and balance_amount=0 )
			BEGIN
			--print 'In';
				Update receipt_mast
				set receipt_status = 1
				where receipt_id = @rd_id
			END
			ELSE IF EXISTS (SELECT 1 FROM receipt_mast WHERE receipt_id = @rd_id and balance_amount>0)
			BEGIN
			--print 'In1';
				Update receipt_mast
				set receipt_status = 0
				where receipt_id = @rd_id
			END
			ELSE
			BEGIN
			--print 'In2';
				Update receipt_mast
				set receipt_status = -1
				where receipt_id = @rd_id
			END
			END


			
			set @sim_id = (Select sales_id from receipt_mast  where receipt_id = @rd_id);

			IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sim_id and net_total>0)
			BEGIN
			IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sim_id and balance_total=0 )
			BEGIN
			--print 'In';
				Update salesinvoice_mast
				set payment_status = 1
				where sales_id = @sim_id;
			END
			ELSE IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sim_id and balance_total>0)
			BEGIN
			--print 'In1';
				Update salesinvoice_mast
				set payment_status = 0
				where sales_id = @sim_id;
			END
			ELSE
			BEGIN
			--print 'In2';
				Update salesinvoice_mast
				set payment_status = -1
				where sales_id = @sim_id;
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
		select rd.receipt_dtl_id,rm.receipt_id,pym.paytype_id,rd.total_amt,rd.cheque_number,rd.ifsc_code,rd.cheque_date,
		rd.account_number,rd.transaction_id,rd.card_number,rd.transaction_date,fym.fin_name,cm.comp_name,rd.created_date,
		rd.updated_date,um.user_id 
		from receipt_details rd 
		left join receipt_mast rm on rd.receipt_id=rm.receipt_id
		left join paytype_mast pym on rd.paytype_id=pym.paytype_id
		left join fin_year_mast fym on rd.fin_year_id=fym.fin_year_id
		left join company_mast cm on rd.comp_id=cm.comp_id
		left join user_mast um on rd.user_id=um.user_id;
		
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
			@ErrorMessage;

			THROW;
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
GO

