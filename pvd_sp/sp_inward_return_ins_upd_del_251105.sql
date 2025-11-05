USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_inward_return_ins_upd_del]    Script Date: 05-11-2025 20:06:29 ******/
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
@user_id bigint=0
)
as
begin

declare @ErrorNumber int, @ErrorProcedure nvarchar(128), @ErrorLine int, @ErrorMessage nvarchar(max);

if @action='insert'
begin
	begin try
		begin transaction
			insert into inward_return(inward_id,customer_id,product_id,returnquantity,remarks,fin_year_id,comp_id,created_date,updated_date,user_id)
			values(@inward_id,@customer_id,@product_id,@returnquantity,@remarks,@fin_year_id,@comp_id,@created_date,@updated_date,@user_id)
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
			user_id=@user_id						
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
		left join user_mast um on ir.user_id=um.user_id;	
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
		select inwardreturn_id,inward_id,customer_id,product_id,returnquantity,remarks,fin_year_id,comp_id,created_date,updated_date,user_id from inward_return where inwardreturn_id=@inwardreturn_id;
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

