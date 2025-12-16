USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_inward_return_ins_upd_del]    Script Date: 16-12-2025 14:48:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE procedure [dbo].[sp_inward_return_ins_upd_del](
@action varchar(max),
@inwardreturn_id bigint=0,
@inward_id bigint=0,
@customer_id bigint=0,
@product_id bigint=0,
@returnquantity decimal(10,2)=0,
@remarks varchar(50)='',
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
			if not EXISTS (Select 1 from user_mast where user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from inward_mast where inward_id = @inward_id)
			Begin
					RAISERROR('Cannot insert: inward_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from inward_return where inward_id = @inward_id and
			product_id=@product_id and customer_id=@customer_id 
			and fin_year_id=@fin_year_id and comp_id=@comp_id)
			Begin
					RAISERROR('Cannot insert: Similar record having same inward_id and fin_year_id and comp_id', 16, 1);
					return;
			End

		if ((@returnquantity > (Select totalquantity from inward_mast where inward_id = @inward_id and fin_year_id=@fin_year_id and comp_id=@comp_id)) or 
		((Select totalquantity from inward_mast where inward_id = @inward_id and fin_year_id=@fin_year_id and comp_id=@comp_id) <= 0))
		Begin
			rollback transaction;
			return;
			
		End

		
			insert into inward_return(inward_id,customer_id,product_id,returnquantity,remarks,fin_year_id,comp_id,created_date,updated_date,created_by,modified_by)
			values(@inward_id,@customer_id,@product_id,@returnquantity,@remarks,@fin_year_id,@comp_id,@created_date,@updated_date,@created_by,@modified_by)
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
			delete from inward_return where inwardreturn_id=@inwardreturn_id
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
			if not EXISTS (Select 1 from user_mast where user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from inward_mast where inward_id = @inward_id)
			Begin
					RAISERROR('Cannot insert: inward_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from inward_return where inward_id = @inward_id and
			product_id=@product_id and customer_id=@customer_id 
			and fin_year_id=@fin_year_id and comp_id=@comp_id and inwardreturn_id<>@inwardreturn_id)
			Begin
					RAISERROR('Cannot insert: Similar record having same inward_id and fin_year_id and comp_id', 16, 1);
					return;
			End

		if ((@returnquantity > (Select totalquantity from inward_mast where inward_id = @inward_id and product_id = @Product_id and fin_year_id=@fin_year_id and comp_id=@comp_id)) or 
		((Select totalquantity from inward_mast where inward_id = @inward_id and product_id = @Product_id and fin_year_id=@fin_year_id and comp_id=@comp_id) <= 0))
		Begin
			rollback transaction;
			return;
			
		End

		

			update inward_return
			set inward_id=@inward_id,
			customer_id=@customer_id,
			product_id=@product_id,
			returnquantity=@returnquantity,
			remarks=@remarks,
			fin_year_id=@fin_year_id,
			comp_id=@comp_id,
			created_date=@created_date,
			updated_date=@updated_date,
			created_by=@created_by,
			modified_by=@modified_by
			where inwardreturn_id=@inwardreturn_id;
				
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
		select ir.inwardreturn_id,ir.inward_id,cm.customer_name,pm.product_name,ir.returnquantity,ir.remarks,fym.fin_name,
		cpm.comp_name,ir.created_date,ir.updated_date,um.user_name 
		from inward_return ir
		left join customer_mast cm on ir.customer_id=cm.customer_id
		left join product_mast pm on ir.product_id=pm.product_id
		left join fin_year_mast fym on ir.fin_year_id=fym.fin_year_id
		left join company_mast cpm on ir.comp_id=cpm.comp_id
		left join user_mast um on ir.created_by=um.user_id;	
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
		select inwardreturn_id,inward_id,customer_id,product_id,returnquantity,remarks,fin_year_id,comp_id,created_date,updated_date,created_by,modified_by from inward_return where inwardreturn_id=@inwardreturn_id;
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

