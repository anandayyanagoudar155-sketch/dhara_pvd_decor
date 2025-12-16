USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_product_mast_ins_upd_del]    Script Date: 16-12-2025 14:15:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_product_mast_ins_upd_del](
@action varchar(max),
@product_id bigint=0,
@prodtype_id bigint=0,
@brand_id bigint=0,
@hsn_id bigint=0,
@unit_id bigint=0,
@product_name varchar(100)='',
@product_desc varchar(max)='',
@rate decimal(12,2)=0,
@created_date date=null,
@updated_date date=null,
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
			if not EXISTS (Select 1 from user_mast where  user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from prodtype_master where prodtype_id = @prodtype_id)
			Begin
					RAISERROR('Cannot insert: prodtype_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from brand_mast where brand_id = @brand_id)
			Begin
					RAISERROR('Cannot insert: brand_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from hsn_mast where hsn_id = @hsn_id)
			Begin
					RAISERROR('Cannot insert: hsn_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from unit_mast where unit_id = @unit_id)
			Begin
					RAISERROR('Cannot insert: unit_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from product_mast where product_name = @product_name)
			Begin
					RAISERROR('Cannot insert: product_name is already present', 16, 1);
					return;
			End
			
			insert into product_mast(prodtype_id,brand_id,hsn_id,unit_id,product_name,product_desc,rate,created_date,updated_date,created_by,modified_by)
			values(@prodtype_id,@brand_id,@hsn_id,@unit_id,@product_name,@product_desc,@rate,@created_date,@updated_date,@created_by,@modified_by);
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
				select count(product_id) as cnt from product_details where product_id = @product_id
				union all
                select count(product_id) as cnt from inward_mast where product_id = @product_id
				union all
                select count(product_id) as cnt from inward_return where product_id = @product_id
				union all
                select count(product_id) as cnt from PurchaseInvoice_Details where product_id = @product_id
				union all
                select count(product_id) as cnt from salesinvoicedetails where product_id = @product_id
				union all
                select count(product_id) as cnt from dailyconsumption_mast where product_id = @product_id
		) as rec_count);
		
		if @rec_count > 0
			begin
				rollback transaction;
				RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
				return;
			end

		delete from product_mast where product_id=@product_id;
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
			if not EXISTS (Select 1 from user_mast where  user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from prodtype_master where prodtype_id = @prodtype_id)
			Begin
					RAISERROR('Cannot insert: prodtype_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from brand_mast where brand_id = @brand_id)
			Begin
					RAISERROR('Cannot insert: brand_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from hsn_mast where hsn_id = @hsn_id)
			Begin
					RAISERROR('Cannot insert: hsn_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from unit_mast where unit_id = @unit_id)
			Begin
					RAISERROR('Cannot insert: unit_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from product_mast where product_name = @product_name 
			and product_id <> @product_id)
			Begin
					RAISERROR('Cannot insert: product_name is already present', 16, 1);
					return;
			End
			update product_mast
			set
			prodtype_id=@prodtype_id,
			brand_id=@brand_id,
			hsn_id=@hsn_id,
			unit_id=@unit_id,
			product_name=@product_name,
			product_desc=@product_desc,
			rate=@rate,
			created_date=@created_date,
			updated_date=@updated_date,
			created_by=@created_by,
			modified_by=@modified_by
			where product_id=@product_id;
			
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
		select a.product_id,
		a.prodtype_id,
		b.prodtype_name,
		a.brand_id,
		c.brand_name,
		a.hsn_id,
		d.hsn_code,
		a.unit_id,
		e.unit_name,
		a.product_name,
		a.product_desc,
		a.rate,
		a.created_date,
		a.updated_date,
		um.user_name 
		from product_mast a
		left join prodtype_master b on a.prodtype_id=b.prodtype_id
		left join brand_mast c on a.brand_id=c.brand_id
		left join hsn_mast d on a.hsn_id=d.hsn_id
		left join unit_mast e on a.unit_id=e.unit_id
		left join user_mast um on a.created_by=um.user_id;
		
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
		select product_id,
		prodtype_id,
		brand_id,
		hsn_id,
		unit_id,
		product_name,
		product_desc,
		rate,
		created_date,
		updated_date,
		created_by,
		modified_by from product_mast where product_id=@product_id;
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



if @action = 'productlist'
begin
	begin try
		select product_id,product_name from product_mast;
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

