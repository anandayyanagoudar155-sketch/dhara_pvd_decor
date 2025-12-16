USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_customer_details_ins_upd_del]    Script Date: 16-12-2025 14:30:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[sp_customer_details_ins_upd_del](
@action varchar(max),
@customer_details_id bigint=0,	
@customer_id bigint=0,	
@opening_balance decimal(12,2)=0,	
@Invoice_balance decimal(12,2)=0,	
@Outstanding_balance decimal(12,2)=0,	
@created_date date = null,	
@updated_date date = null,	
@fin_year_id  bigint=0,	
@comp_id bigint=0,	
@created_by bigint=0,
@modified_by bigint=0
)
as
begin

declare @ErrorNumber int, @ErrorProcedure nvarchar(128), @ErrorLine int, @ErrorMessage nvarchar(max);

if @action='insert'
begin
	begin try
		begin transaction
			if not EXISTS (Select 1 from customer_mast where customer_id = @customer_id)
			Begin
					RAISERROR('Cannot insert: customer_id is incorrect', 16, 1);
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
			if not EXISTS (Select 1 from user_mast where user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from customer_details where customer_id = @customer_id
			and fin_year_id=@fin_year_id and comp_id=@comp_id)
			Begin
					RAISERROR('Cannot insert: Similar record having same customer_id and fin_year_id and comp_id', 16, 1);
					return;
			End
			
			insert into customer_details(customer_id,opening_balance,Invoice_balance,Outstanding_balance,created_date,updated_date,fin_year_id,comp_id,created_by,modified_by)
			values(@customer_id,@opening_balance,@Invoice_balance,@Outstanding_balance,@created_date,@updated_date,@fin_year_id,@comp_id,@created_by,@modified_by);
			;WITH cte AS (
				SELECT *,
					   ROW_NUMBER() OVER (ORDER BY fin_year_id) AS rn
				FROM customer_details
				WHERE customer_id = @customer_id and 
				comp_id=@comp_id	  
			)
			SELECT @opening_balance = isnull(c2.Outstanding_balance,0)
			FROM cte c1
			JOIN cte c2 ON c2.rn = c1.rn - 1
			WHERE c1.fin_year_id = @fin_year_id;
			
			set @Invoice_balance= (isnull((
									Select sid.total_amt
									from salesinvoicedetails sid
									inner join salesinvoice_mast sim on sid.sales_id = sim.sales_id
									where 
									sim.customer_id = @customer_id and
									sid.comp_id = @comp_id and 
									sid.fin_year_id = @fin_year_id
								  ),0)-isnull((
									Select rd.total_amt
									from receipt_details rd
									inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
									inner join salesinvoice_mast sim on rm.sales_id = sim.sales_id
									where 
									sim.customer_id = @customer_id and
									rd.comp_id = @comp_id and 
									rd.fin_year_id = @fin_year_id
								    ),0));
			set @Outstanding_balance = isnull((@opening_balance + @Invoice_balance),0);
			update customer_details
			set opening_balance = @opening_balance,
				Invoice_balance = @Invoice_balance,
				Outstanding_balance = @Outstanding_balance
				where customer_id = @customer_id and
				comp_id = @comp_id and
				fin_year_id = @fin_year_id;

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
		

		delete from customer_details where customer_details_id=@customer_details_id
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
			if not EXISTS (Select 1 from customer_mast where customer_id = @customer_id)
			Begin
					RAISERROR('Cannot insert: customer_id is incorrect', 16, 1);
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
			if not EXISTS (Select 1 from user_mast where user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from customer_details where customer_id = @customer_id
			and fin_year_id=@fin_year_id and comp_id=@comp_id and customer_details_id<>@customer_details_id)
			Begin
					RAISERROR('Cannot insert: Similar record having same customer_id and fin_year_id and comp_id', 16, 1);
					return;
			End
			;WITH cte AS (
				SELECT *,
					   ROW_NUMBER() OVER (ORDER BY fin_year_id) AS rn
				FROM customer_details
				WHERE customer_id = @customer_id and 
				comp_id=@comp_id	  
			)
			SELECT @opening_balance = isnull(c2.Outstanding_balance,0)
			FROM cte c1
			JOIN cte c2 ON c2.rn = c1.rn - 1
			WHERE c1.fin_year_id = @fin_year_id;

			set @Invoice_balance= (isnull((
									Select sid.total_amt
									from salesinvoicedetails sid
									inner join salesinvoice_mast sim on sid.sales_id = sim.sales_id
									where 
									sim.customer_id = @customer_id and
									sid.comp_id = @comp_id and 
									sid.fin_year_id = @fin_year_id
								  ),0)-isnull((
									Select rd.total_amt
									from receipt_details rd
									inner join receipt_mast rm on rd.receipt_id = rm.receipt_id
									inner join salesinvoice_mast sim on rm.sales_id = sim.sales_id
									where 
									sim.customer_id = @customer_id and
									rd.comp_id = @comp_id and 
									rd.fin_year_id = @fin_year_id
								    ),0));
			set @Outstanding_balance = isnull((@opening_balance + @Invoice_balance),0)

			update customer_details 
			set 
			customer_id=@customer_id,
			opening_balance=@opening_balance,
			Invoice_balance=@Invoice_balance,
			Outstanding_balance=@Outstanding_balance,
			created_date=@created_date,
			updated_date=@updated_date,
			fin_year_id=@fin_year_id,
			comp_id = @comp_id,
			created_by = @created_by,
			modified_by = @modified_by
				where customer_details_id=@customer_details_id
				
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
		select 
			cd.customer_details_id,
			cm.customer_id,
			cd.opening_balance,
			cd.Invoice_balance,
			cd.Outstanding_balance,
			cd.created_date,
			cd.updated_date,
			fym.fin_year_id,
			cpm.comp_id,
			um.user_name			
		from customer_details cd
		left join customer_mast cm on cd.customer_id=cm.customer_id
		left join fin_year_mast fym on cd.fin_year_id=fym.fin_year_id
		left join company_mast cpm on cd.comp_id = cpm.comp_id
		left join user_mast um on cd.created_by=um.user_id;
		
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
			select 
			cd.customer_details_id,
			cd.customer_id,
			cd.opening_balance,
			cd.Invoice_balance,
			cd.Outstanding_balance,
			cd.created_date,
			cd.updated_date,
			cd.fin_year_id,
			cd.comp_id,
			cd.created_by,	
			cd.modified_by
		from customer_details cd
		where customer_details_id = @customer_details_id;
		
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

