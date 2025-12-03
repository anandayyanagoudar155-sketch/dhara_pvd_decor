USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_product_details_ins_upd_del]    Script Date: 03-12-2025 17:31:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_product_details_ins_upd_del](
@action varchar(max),
@product_details_id	bigint=0,
@product_id bigint=0,
@opening_stock decimal(10,2)=0,
@purchase decimal(10,2)=0,
@sales decimal(10,2)=0,
@return decimal(10,2)=0,
@current_stock decimal(10,2)=0,
@reorder_threshold decimal(10,2)=0,
@reorder_desc varchar(max)='',
@created_date date=null,
@updated_date date=null,
@fin_year_id bigint=0,
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
			insert into product_details(product_id,opening_stock,purchase,sales,[return],reorder_threshold,reorder_desc,created_date,updated_date,fin_year_id,comp_id,user_id)
			values(@product_id,@opening_stock,@purchase,@sales,@return,@reorder_threshold,@reorder_desc,@created_date,@updated_date,@fin_year_id,@comp_id,@user_id);
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

		delete from product_details where product_details_id=@product_details_id;
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
			update product_details
			set
			product_id = @product_id,
			opening_stock=@opening_stock,
			purchase=@purchase,
			sales=@sales,
			[return]=@return,
			reorder_threshold=@reorder_threshold,
			reorder_desc=@reorder_desc,
			created_date=@created_date,
			updated_date=@updated_date,
			fin_year_id = @fin_year_id,
			comp_id = @comp_id,
			user_id=@user_id
			where 
			product_details_id=@product_details_id;
			
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
		a.product_details_id,
		b.product_id,
		a.opening_stock,
		a.purchase,
		a.sales,
		a.[return],
		a.current_stock,
		a.reorder_threshold,
		a.reorder_desc,
		a.created_date,
		a.updated_date,
		c.fin_year_id,
		d.comp_id,
		um.user_name 
		from product_details a
		left join product_mast b on a.product_id=b.product_id
		left join fin_year_mast c on a.fin_year_id=c.fin_year_id
		left join company_mast d on a.comp_id=d.comp_id
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
		select 
		product_details_id,
		product_id,
		opening_stock,
		purchase,
		sales,
		[return],
		current_stock,
		reorder_threshold,
		reorder_desc,
		created_date,
		updated_date,
		fin_year_id,
		comp_id,
		user_id 
		from product_details 
		where product_details_id=@product_details_id;
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

