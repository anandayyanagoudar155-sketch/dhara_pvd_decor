USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_inward_mast_ins_upd_del]    Script Date: 03-12-2025 17:22:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE procedure [dbo].[sp_inward_mast_ins_upd_del](
@action varchar(max)=null,
@inward_id bigint=0,
@customer_id bigint=0,
@product_id bigint=0,
@totalquantity decimal(10,2)=0,
@balance decimal(10,2)=0,
@inward_status bit=0,
@remarks varchar(50)='',
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
			if not EXISTS (Select 1 from customer_mast where customer_id = @customer_id)
			Begin
					RAISERROR('Cannot insert: customer_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from product_mast where product_id = @product_id)
			Begin
					RAISERROR('Cannot insert: product_id is incorrect', 16, 1);
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
			set @balance = @totalquantity;
			insert into inward_mast(customer_id,product_id,totalquantity,balance_quantity,inward_status,remarks,fin_year_id,comp_id,created_date,updated_date,user_id)
			values(@customer_id,@product_id,@totalquantity,@balance,@inward_status,@remarks,@fin_year_id,@comp_id,@created_date,@updated_date,@user_id);
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
		set @rec_count = (select sum(cnt)
			from (
			select count(inward_id) as cnt from salesinvoicedetails where inward_id = @inward_id
			union all
			select count(inward_id) as cnt from inward_return where inward_id = @inward_id
		) as rec_count);
		
		if @rec_count > 0
			begin
				rollback transaction;
				RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
				return;
			end

		delete from inward_mast where inward_id=@inward_id;
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
			if not EXISTS (Select 1 from product_mast where product_id = @product_id)
			Begin
					RAISERROR('Cannot insert: product_id is incorrect', 16, 1);
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
		set @balance = @totalquantity;
			update inward_mast
			set customer_id=@customer_id,
			product_id=@product_id,
			totalquantity=@totalquantity,
			balance_quantity=@balance,
			inward_status=@inward_status,
			remarks=@remarks,
			fin_year_id=@fin_year_id,
			comp_id=@comp_id,
			created_date=@created_date,
			updated_date=@updated_date,
			user_id=@user_id
			where inward_id=@inward_id;
			
			
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
		a.inward_id,
		b.customer_name,
		c.product_name,
		a.totalquantity,
		a.balance_quantity,
		a.inward_status,
		a.remarks,
		fym.fin_year_id,
		cm.comp_id,
		a.created_date,
		a.updated_date,
		um.user_id 
		from inward_mast a
		left join customer_mast b on a.customer_id=b.customer_id
		left join product_mast c on a.product_id=c.product_id
		left join fin_year_mast fym on a.fin_year_id=fym.fin_year_id
		left join company_mast cm on a.comp_id=cm.comp_id
		left join user_mast um on a.user_id=um.user_id;
		
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
		select inward_id,customer_id,product_id,totalquantity,balance_quantity,inward_status,remarks,fin_year_id,comp_id,created_date,updated_date,user_id from inward_mast where inward_id=@inward_id;
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

