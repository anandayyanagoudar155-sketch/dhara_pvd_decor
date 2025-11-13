USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_dailyconsumption_mast_ins_upd_del]    Script Date: 13-11-2025 10:54:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_dailyconsumption_mast_ins_upd_del](
@action varchar(max) = '',
@dailycons_id bigint = 0 ,
@dailycons_date date = null,
@product_id	bigint = 0,
@unit_id	bigint = 0,
@quantityconsumed decimal(10,2) = 0,		
@purpose	varchar(max) = '',	
@fin_year_id bigint = 0,
@comp_id bigint = 0,
@created_date date = null,
@updated_date date = null,
@user_id bigint = 0
)
as
Begin
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);

	if @action = 'insert'
	begin
		begin try
			begin transaction
			insert into dailyconsumption_mast(dailycons_date,product_id,unit_id,quantityconsumed,purpose,fin_year_id,
			comp_id,created_date,updated_date,user_id)
			values(@dailycons_date,@product_id,@unit_id,@quantityconsumed,@purpose,@fin_year_id,@comp_id,
			@created_date,@updated_date,@user_id);
			commit transaction;
		end try
		begin catch
			IF XACT_STATE() <> 0
			rollback transaction;

			set @errornumber = ERROR_NUMBER();
			set @errorprocedure = ERROR_PROCEDURE();
			set @errorline = ERROR_LINE();
			set @errormessage = ERROR_MESSAGE();

			exec errorlog_ins 
				 @errornumber,
				 @errorprocedure,
				 @errorline,
				 @errormessage;	

			THROW;
		end catch
	end

	if @action = 'select all'
	begin
		begin try
			Select dcm.dailycons_id,dcm.dailycons_date,pm.product_name,utm.unit_name,dcm.quantityconsumed,
			dcm.purpose,fym.fin_name,cm.comp_name,dcm.created_date,dcm.updated_date,um.user_name
			from dailyconsumption_mast dcm
			left join user_mast um on dcm.user_id = um.user_id
			left join company_mast cm on dcm.comp_id = cm.comp_id
			left join fin_year_mast fym on dcm.fin_year_id = fym.fin_year_id
			left join product_mast pm on dcm.product_id = pm.product_id
			left join unit_mast utm on dcm.unit_id = utm.unit_id;
		end try
		begin catch
			set @errornumber = ERROR_NUMBER();
			set @errorprocedure = ERROR_PROCEDURE();
			set @errorline = ERROR_LINE();
			set @errormessage = ERROR_MESSAGE();

			exec errorlog_ins 
				 @errornumber,
				 @errorprocedure,
				 @errorline,
				 @errormessage;

			THROW;
		end catch
	end

	if @action = 'select one'
	begin
		begin try
			Select dcm.dailycons_id,dcm.dailycons_date,dcm.product_id,dcm.unit_id,dcm.quantityconsumed,
			dcm.purpose,dcm.fin_year_id,dcm.comp_id,dcm.created_date,dcm.updated_date,dcm.user_id
			from dailyconsumption_mast dcm
			where dcm.dailycons_id=@dailycons_id;
		end try
		begin catch
			set @errornumber = ERROR_NUMBER();
			set @errorprocedure = ERROR_PROCEDURE();
			set @errorline = ERROR_LINE();
			set @errormessage = ERROR_MESSAGE();

			exec errorlog_ins 
				 @errornumber,
				 @errorprocedure,
				 @errorline,
				 @errormessage;

			THROW;
		end catch
	end

	if @action = 'delete'
	begin
		begin try
			begin transaction;
			
			delete from dailyconsumption_mast where dailycons_id = @dailycons_id;
			commit transaction;
		end try
		begin catch
			If XACT_STATE() <> 0
			rollback transaction;

			set @errornumber = ERROR_NUMBER();
			set @errorprocedure = ERROR_PROCEDURE();
			set @errorline = ERROR_LINE();
			set @errormessage = ERROR_MESSAGE();

			exec errorlog_ins 
				 @errornumber,
				 @errorprocedure,
				 @errorline,
				 @errormessage;	
				 
			THROW;
		end catch
	end

	if @action = 'update'
	begin
		begin try
			begin transaction
			update dailyconsumption_mast
			set dailycons_date = @dailycons_date,
				product_id	= @product_id,
				unit_id	 = @unit_id,
				quantityconsumed = @quantityconsumed,		
				purpose	 = @purpose,	
				fin_year_id = @fin_year_id,
				comp_id = @comp_id,
				created_date = @created_date,
				updated_date = @updated_date,
				user_id = @user_id
			where dailycons_id = @dailycons_id;

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

			set @errornumber = ERROR_NUMBER();
			set @errorprocedure = ERROR_PROCEDURE();
			set @errorline = ERROR_LINE();
			set @errormessage = ERROR_MESSAGE();

			exec errorlog_ins 
				 @errornumber,
				 @errorprocedure,
				 @errorline,
				 @errormessage;	
				 
			THROW;
		end catch
	end
	
End
GO

