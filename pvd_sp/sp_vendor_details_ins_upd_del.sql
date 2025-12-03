USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_vendor_details_ins_upd_del]    Script Date: 03-12-2025 18:30:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE procedure [dbo].[sp_vendor_details_ins_upd_del](
@action varchar(max),
@vendor_details_id bigint=0,	
@vendor_id bigint=0,	
@opening_balance decimal(12,2)=0,	
@Invoice_balance decimal(12,2)=0,	
@Outstanding_balance decimal(12,2)=0,	
@created_date date = null,	
@updated_date date = null,	
@fin_year_id  bigint=0,	
@comp_id bigint=0,	
@user_id bigint=0
)
as
begin

declare @ErrorNumber int, @ErrorProcedure nvarchar(128), @ErrorLine int, @ErrorMessage nvarchar(max);

if @action='insert'
begin
	begin try
		begin transaction
			if not EXISTS (Select 1 from vendor_mast where vendor_id = @vendor_id)
			Begin
					RAISERROR('Cannot insert: vendor_id is incorrect', 16, 1);
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
			if EXISTS (Select 1 from vendor_details where vendor_id = @vendor_id
			and fin_year_id=@fin_year_id and comp_id=@comp_id)
			Begin
					RAISERROR('Cannot insert: Similar record having same vendor_id and fin_year_id and comp_id', 16, 1);
					return;
			End
			
			insert into vendor_details(vendor_id,opening_balance,Invoice_balance,Outstanding_balance,created_date,updated_date,fin_year_id,comp_id,user_id)
			values(@vendor_id,@opening_balance,@Invoice_balance,@Outstanding_balance,@created_date,@updated_date,@fin_year_id,@comp_id,@user_id);
			;WITH cte AS (
				SELECT *,
					   ROW_NUMBER() OVER (ORDER BY fin_year_id) AS rn
				FROM vendor_details
				WHERE vendor_id = @vendor_id and 
				comp_id=@comp_id	  
			)
			SELECT @opening_balance = isnull(c2.Outstanding_balance,0)
			FROM cte c1
			JOIN cte c2 ON c2.rn = c1.rn - 1
			WHERE c1.fin_year_id = @fin_year_id;

			set @Invoice_balance= (isnull((
									Select pid.total_amt
									from purchaseinvoice_details pid
									inner join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
									where 
									pim.vendor_id = @vendor_id and
									pid.comp_id = @comp_id and 
									pid.fin_year_id = @fin_year_id
								  ),0)-isnull((
									Select pd.total_amount
									from payment_details pd
									inner join payment_mast pm on pd.payment_id = pm.payment_id
									inner join purchaseinvoice_mast pim on pm.purchase_id = pim.purchase_id
									where 
									pim.vendor_id = @vendor_id and
									pd.comp_id = @comp_id and 
									pd.fin_year_id = @fin_year_id
								    ),0));
			set @Outstanding_balance = isnull((@opening_balance + @Invoice_balance),0);
			update vendor_details
			set opening_balance = @opening_balance,
				Invoice_balance = @Invoice_balance,
				Outstanding_balance = @Outstanding_balance
				where vendor_id = @vendor_id and
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
		

		delete from vendor_details where vendor_details_id=@vendor_details_id
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
			if not EXISTS (Select 1 from vendor_mast where vendor_id = @vendor_id)
			Begin
					RAISERROR('Cannot insert: vendor_id is incorrect', 16, 1);
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
			if EXISTS (Select 1 from vendor_details where vendor_id = @vendor_id
			and fin_year_id=@fin_year_id and comp_id=@comp_id and vendor_details_id<>@vendor_details_id)
			Begin
					RAISERROR('Cannot insert: Similar record having same vendor_id and fin_year_id and comp_id', 16, 1);
					return;
			End
			;WITH cte AS (
				SELECT *,
					   ROW_NUMBER() OVER (ORDER BY fin_year_id) AS rn
				FROM vendor_details
				WHERE vendor_id = @vendor_id and 
				comp_id=@comp_id	  
			)
			SELECT @opening_balance = isnull(c2.Outstanding_balance,0)
			FROM cte c1
			JOIN cte c2 ON c2.rn = c1.rn - 1
			WHERE c1.fin_year_id = @fin_year_id;
			set @Invoice_balance= (isnull((
									Select pid.total_amt
									from purchaseinvoice_details pid
									inner join purchaseinvoice_mast pim on pid.purchase_id = pim.purchase_id
									where 
									pim.vendor_id = @vendor_id and
									pid.comp_id = @comp_id and 
									pid.fin_year_id = @fin_year_id
								  ),0)-isnull((
									Select pd.total_amount
									from payment_details pd
									inner join payment_mast pm on pd.payment_id = pm.payment_id
									inner join purchaseinvoice_mast pim on pm.purchase_id = pim.purchase_id
									where 
									pim.vendor_id = @vendor_id and
									pd.comp_id = @comp_id and 
									pd.fin_year_id = @fin_year_id
								    ),0));
			set @Outstanding_balance = isnull((@opening_balance + @Invoice_balance),0)

			update vendor_details 
			set 
			vendor_id=@vendor_id,
			opening_balance=@opening_balance,
			Invoice_balance=@Invoice_balance,
			Outstanding_balance=@Outstanding_balance,
			created_date=@created_date,
			updated_date=@updated_date,
			fin_year_id=@fin_year_id,
			comp_id = @comp_id,
			user_id = @user_id
				where vendor_details_id=@vendor_details_id
				
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
			vd.vendor_details_id,
			vm.vendor_id,
			vd.opening_balance,
			vd.Invoice_balance,
			vd.Outstanding_balance,
			vd.created_date,
			vd.updated_date,
			fym.fin_year_id,
			cpm.comp_id,
			um.user_id			
		from vendor_details vd
		left join vendor_mast vm on vd.vendor_id=vm.vendor_id
		left join fin_year_mast fym on vd.fin_year_id=fym.fin_year_id
		left join company_mast cpm on vd.comp_id = cpm.comp_id
		left join user_mast um on vd.user_id=um.user_id;
		
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
			vd.vendor_details_id,
			vd.vendor_id,
			vd.opening_balance,
			vd.Invoice_balance,
			vd.Outstanding_balance,
			vd.created_date,
			vd.updated_date,
			vd.fin_year_id,
			vd.comp_id,
			vd.user_id			
		from vendor_details vd
		where vendor_details_id = @vendor_details_id;
		
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

