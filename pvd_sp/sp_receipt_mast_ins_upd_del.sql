USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_receipt_mast_ins_upd_del]    Script Date: 16-12-2025 15:10:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO












CREATE procedure [dbo].[sp_receipt_mast_ins_upd_del](
@action varchar(max),
@receipt_id bigint=0,
@sales_id bigint=0,
@customer_id bigint=0,
@recepit_date date=null,
@net_total decimal(12,2)=0,
@Net_Paid_total decimal(12,2)=0,
@balance_amount decimal(12,2)=0,
@receipt_status bit=0,
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
declare @sid bigint;
declare @fid bigint;
declare @cid bigint;
declare @opening_balance decimal(12,2);
if @action='insert'
begin
	

	begin try
		begin transaction
			
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

			if (@sales_id is not null or @sales_id <> 0)
			Begin
				set @net_total = isnull((Select net_total from salesinvoice_mast where sales_id = @sales_id),0);
				set @Net_Paid_total = isnull((
										  Select sum(rd.total_amt) as reduced_amt
										  from receipt_details rd
										  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
										  where rm.sales_id=@sales_id and rd.fin_year_id=@fin_year_id and 
										 rd.comp_id=@comp_id ),0)
				set @balance_amount = @net_total - @Net_Paid_total;
			End
			Else
			Begin
				set @opening_balance = isnull((Select opening_balance  from customer_details cd 
								  where customer_id=@customer_id and fin_year_id=@fin_year_id 
								  and comp_id=@comp_id),0);
				if (@Net_Paid_total>@opening_balance or @opening_balance<=0)
				Begin
					RAISERROR('The payment amount is more than balance amount', 16, 1);
					return;
				End

				set @net_total = @opening_balance;
				set @balance_amount = @net_total-@Net_Paid_total;
			End


			insert into receipt_mast(sales_id,customer_id,recepit_date,net_total,Net_Paid_total,balance_amount,receipt_status,fin_year_id,comp_id,created_date,updated_date,created_by,modified_by)
			values(@sales_id,@customer_id,@recepit_date,@net_total,@Net_Paid_total,@balance_amount,@receipt_status,@fin_year_id,@comp_id,@created_date,@updated_date,@created_by,@modified_by);
			
			if (@sales_id is null or @sales_id = 0)
			Begin
			Update customer_details
				set opening_balance = isnull((Select opening_balance  from customer_details cd 
								  where customer_id=@customer_id and fin_year_id=@fin_year_id 
								  and comp_id=@comp_id),0) - @Net_Paid_total,
				   Outstanding_balance = (isnull((Select opening_balance  from customer_details cd 
								  where customer_id=@customer_id and fin_year_id=@fin_year_id 
								  and comp_id=@comp_id),0) - @Net_Paid_total) + Invoice_balance
				where customer_id=@customer_id and fin_year_id=@fin_year_id and comp_id=@comp_id; 
			End
			
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
            select count(receipt_id) as cnt  from receipt_details where receipt_id = @receipt_id 
		) as recount);
		
		if @rec_count > 0
		begin
			rollback transaction;
			RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
			return;
		end

		set @sid = isnull((Select sales_id from receipt_mast where receipt_id=@receipt_id),0);
		set @fid = isnull((Select fin_year_id from receipt_mast where receipt_id=@receipt_id),0);
		set @cid = isnull((Select comp_id from receipt_mast where receipt_id=@receipt_id),0);
		set @customer_id = isnull((Select customer_id from receipt_mast where receipt_id=@receipt_id),0);
		
		if (@sid is null or @sid = 0)
			Begin
				set @Net_Paid_total = isnull((Select Net_Paid_total from receipt_mast where receipt_id=@receipt_id),0);
				set @net_total = isnull((Select net_total from receipt_mast where receipt_id=@receipt_id),0);
			End


		delete from receipt_mast where receipt_id=@receipt_id;

		if (@sid is null or @sid = 0)
			Begin
			
				Update customer_details
				set opening_balance = isnull((Select opening_balance  from customer_details cd 
									  where customer_id=@customer_id and fin_year_id=@fid 
									  and comp_id=@cid),0) + @Net_Paid_total,
				Outstanding_balance = (isnull((Select opening_balance  from customer_details cd 
									  where customer_id=@customer_id and fin_year_id=@fid 
									  and comp_id=@cid),0) + @Net_Paid_total) + Invoice_balance
				where customer_id=@customer_id and fin_year_id=@fid and comp_id=@cid; 
			End
			

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
			declare @Net_Paid_total_prev bigint;
			set @Net_Paid_total_prev = (Select Net_Paid_total from receipt_mast where receipt_id=@receipt_id)
			if (@sales_id is not null or @sales_id <> 0)
					Begin
						set @net_total = isnull((select SUM(total_amt) 
										from salesinvoicedetails sid
										inner join salesinvoice_mast sim on sid.sales_id = sim.sales_id
										where sid.sales_id=@sales_id and sid.fin_year_id=@fin_year_id and
										sid.comp_id=@comp_id),0);
						set @Net_Paid_total = isnull((
										  Select sum(rd.total_amt) as reduced_amt
										  from receipt_details rd
										  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
										  where rm.sales_id=@sales_id and rd.fin_year_id=@fin_year_id and 
										 rd.comp_id=@comp_id ),0);
						set @balance_amount = (
										isnull((select SUM(total_amt) 
										from salesinvoicedetails sid
										inner join salesinvoice_mast sim on sid.sales_id = sim.sales_id
										where sid.sales_id=@sales_id and sid.fin_year_id=@fin_year_id and
										sid.comp_id=@comp_id),0) 
										) - 
										( 
											isnull((
											  Select sum(rd.total_amt) as reduced_amt
											  from receipt_details rd
											  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
											  where rm.sales_id=@sales_id and rd.fin_year_id=@fin_year_id and 
											 rd.comp_id=@comp_id ),0)
										 );
					End
					Else
					Begin
						set @opening_balance = isnull((Select opening_balance  from customer_details cd 
										  where customer_id=@customer_id and fin_year_id=@fin_year_id 
										  and comp_id=@comp_id),0) + @Net_Paid_total_prev;
						if (@Net_Paid_total>@opening_balance or @opening_balance<=0)
						Begin
							RAISERROR('The payment amount is more than balance amount', 16, 1);
							return;
						End

						set @net_total = @opening_balance;
						set @balance_amount = @net_total-@Net_Paid_total;
			End
			
			
			update receipt_mast 
			set sales_id=@sales_id,
			customer_id=@customer_id,
			recepit_date=@recepit_date,
			net_total=@net_total,
			Net_Paid_total=@Net_Paid_total,
			balance_amount=@balance_amount,
			receipt_status=@receipt_status,
			fin_year_id=@fin_year_id,
			comp_id=@comp_id,
			created_date=@created_date,
			updated_date=@updated_date,
			created_by=@created_by,
			modified_by=@modified_by
				where receipt_id=@receipt_id;

		
				if (@sales_id is null or @sales_id = 0)
					Begin
						Update customer_details
						set opening_balance = (isnull((Select opening_balance  from customer_details cd 
										  where customer_id=@customer_id and fin_year_id=@fin_year_id 
										  and comp_id=@comp_id),0) + @Net_Paid_total_prev) - @Net_Paid_total,
						   Outstanding_balance = ((isnull((Select opening_balance  from customer_details cd 
										  where customer_id=@customer_id and fin_year_id=@fin_year_id 
										  and comp_id=@comp_id),0) + @Net_Paid_total_prev) - @Net_Paid_total) + Invoice_balance
						where customer_id=@customer_id and fin_year_id=@fin_year_id and comp_id=@comp_id; 
					End
				Else
					Begin
						

						Update sim
						set net_total= isnull((select SUM(total_amt) 
										from salesinvoicedetails sid
										inner join salesinvoice_mast sim on sid.sales_id = sim.sales_id
										where sid.sales_id=@sales_id and sid.fin_year_id=@fin_year_id and
										sid.comp_id=@comp_id),0),
							balance_total =(
											isnull((select SUM(total_amt) 
											from salesinvoicedetails sid
											inner join salesinvoice_mast sim on sid.sales_id = sim.sales_id
											where sid.sales_id=@sales_id and sid.fin_year_id=@fin_year_id and
											sid.comp_id=@comp_id),0) 
											) - 
											( 
												isnull((
												  Select sum(rd.total_amt) as reduced_amt
												  from receipt_details rd
												  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
												  where rm.sales_id=@sales_id and rd.fin_year_id=@fin_year_id and 
												 rd.comp_id=@comp_id ),0)
											 )
						from salesinvoice_mast sim
						where sim.sales_id = @sales_id;

						update customer_details
						set Invoice_balance =(
											isnull((select SUM(total_amt) 
											from salesinvoicedetails sid
											inner join salesinvoice_mast sim on sid.sales_id = sim.sales_id
											where sid.sales_id=@sales_id and sid.fin_year_id=@fin_year_id and
											sid.comp_id=@comp_id),0) 
											) - 
											( 
												isnull((
												  Select sum(rd.total_amt) as reduced_amt
												  from receipt_details rd
												  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
												  where rm.sales_id=@sales_id and rd.fin_year_id=@fin_year_id and 
												 rd.comp_id=@comp_id ),0)
											 ),
							Outstanding_balance = opening_balance + (
																	(
																	isnull((select SUM(total_amt) 
																	from salesinvoicedetails sid
																	inner join salesinvoice_mast sim on sid.sales_id = sim.sales_id
																	where sid.sales_id=@sales_id and sid.fin_year_id=@fin_year_id and
																	sid.comp_id=@comp_id),0) 
																	) - 
																	( 
																		isnull((
																		  Select sum(rd.total_amt) as reduced_amt
																		  from receipt_details rd
																		  inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
																		  where rm.sales_id=@sales_id and rd.fin_year_id=@fin_year_id and 
																		 rd.comp_id=@comp_id ),0)
																	 )
																	)
							where customer_id=@customer_id and fin_year_id=@fin_year_id and comp_id=@comp_id;

					End

		
				IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sales_id and net_total>0)
				BEGIN
				IF EXISTS (SELECT 1 FROM salesinvoice_mast WHERE sales_id = @sales_id and balance_total=0)
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

				IF EXISTS (SELECT 1 FROM receipt_mast WHERE receipt_id = @receipt_id and net_total>0)
				BEGIN
				IF EXISTS (SELECT 1 FROM receipt_mast WHERE receipt_id = @receipt_id and balance_amount=0)
				BEGIN
					Update receipt_mast
					set receipt_status = 1
					where receipt_id = @receipt_id;
				END
				ELSE IF EXISTS (SELECT 1 FROM receipt_mast WHERE receipt_id = @receipt_id and balance_amount>0)
				BEGIN
					Update receipt_mast
					set receipt_status = 0
					where receipt_id = @receipt_id;
				END
				ELSE
				BEGIN
					Update receipt_mast
					set receipt_status = -1
					where receipt_id = @receipt_id;
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
		select rm.receipt_id,sim.sales_id,rm.recepit_date,rm.net_total,rm.balance_amount,rm.receipt_status,fym.fin_name,
		cm.comp_name,rm.created_date,rm.updated_date,um.user_name 
		from receipt_mast rm
		left join salesinvoice_mast sim on rm.sales_id=sim.sales_id
		left join fin_year_mast fym on rm.fin_year_id=fym.fin_year_id
		left join company_mast cm on rm.comp_id=cm.comp_id
		left join user_mast um on rm.created_by=um.user_id; 	
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
		select receipt_id,sales_id,recepit_date,net_total,balance_amount,receipt_status,fin_year_id,comp_id,created_date,updated_date,created_by,modified_by from receipt_mast where receipt_id=@receipt_id; 	
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
	
	

if @action = 'receiptlist'
begin
	begin try
		select receipt_id,sales_id from receipt_mast
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

