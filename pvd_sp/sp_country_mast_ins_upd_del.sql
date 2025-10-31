USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_country_mast_ins_upd_del]    Script Date: 31-10-2025 16:40:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[sp_country_mast_ins_upd_del](
@action varchar(max) = '',
@country_id bigint = 0,
@country_name varchar(100) = '',
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
			insert into country_mast(country_name,created_date,updated_date,user_id)
			values(@country_name,@created_date,@updated_date,@user_id);
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
		end catch
	end

	if @action = 'select all'
	begin
		begin try
			select country_id,country_name,created_date,updated_date,user_id 
			from country_mast;	
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
		end catch
	end

	if @action = 'select one'
	begin
		begin try
			select country_id,country_name,created_date,updated_date,user_id 
			from country_mast
			where country_id=@country_id;
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
		end catch
	end

	if @action = 'delete'
	begin
		declare @rec_count bigint = 0
		set @rec_count = (Select count(country_id) from country_mast where country_id = @country_id)

		if @rec_count > 0
		begin try
			begin transaction;
			set @rec_count =(select COUNT(country_id) from state_mast where country_id=@country_id);

			if @rec_count>0
			begin
				rollback transaction;
				return;
			end

			delete from country_mast where country_id = @country_id;
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
		end catch
	end

	if @action = 'update'
	begin
		begin try
			begin transaction
			update country_mast
			set country_name=@country_name,
				updated_date=@updated_date
			where country_id = @country_id;

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
		end catch
	end
	if @action = 'country_mastlist'
	begin
		begin try
			select country_id,country_name from country_mast;
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
		end catch
	end

End
GO

