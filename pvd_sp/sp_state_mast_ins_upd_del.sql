USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_state_mast_ins_upd_del]    Script Date: 31-10-2025 16:47:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_state_mast_ins_upd_del](
@action varchar(max) = '',
@state_id bigint = 0,
@state_name varchar(100) = '',
@country_id bigint = 0,
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
			insert into state_mast(state_name,country_id,created_date,updated_date,user_id)
			values(@state_name,@country_id,@created_date,@updated_date,@user_id);
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
			select state_id,state_name,country_id,created_date,updated_date,user_id 
			from state_mast;	
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
			select state_id,state_name,country_id,created_date,updated_date,user_id 
			from state_mast
			where state_id=@state_id;
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
		declare @rec_count bigint = 0;
		set @rec_count = (Select count(state_id) from state_mast where state_id = @state_id);

		if @rec_count > 0
		begin try
			begin transaction;
			set @rec_count =(select COUNT(city_Id) from city_Mast where state_Id=@state_id);

			if @rec_count>0
			begin
				rollback transaction;
				return;
			end

			delete from state_mast where state_id = @state_id;
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
			update state_mast
			set state_name=@state_name,
				country_id=@country_id,
				updated_date=@updated_date
			where state_id = @state_id;

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
	if @action = 'state_mastlist'
	begin
		begin try
			select state_id,state_name from state_mast;
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

