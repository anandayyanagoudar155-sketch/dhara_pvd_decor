USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_state_mast_ins_upd_del]    Script Date: 24-11-2025 20:02:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









CREATE procedure [dbo].[sp_state_mast_ins_upd_del](
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

			if not EXISTS (Select 1 from user_mast where user_id = @user_id)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from state_mast where state_name = @state_name)
			Begin
					RAISERROR('Cannot insert: state_name is already present', 16, 1);
					return;
			End

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
				 
			THROW;
		end catch
	end

	if @action = 'select all'
	begin
		begin try
			select sm.state_id,sm.state_name,cm.country_name,sm.created_date,sm.updated_date,um.user_name 
			from state_mast sm
			left join country_mast cm on sm.country_id = cm.country_id
			left join user_mast um on sm.user_id=um.user_id;	
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
			select sm.state_id,sm.state_name,sm.country_id,sm.created_date,sm.updated_date,sm.user_id 
			from state_mast sm	
			where sm.state_id=@state_id;
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
		declare @rec_count bigint = 0;
		begin try
			begin transaction;
			set @rec_count =(
								Select sum(cnt) from 
								(
									select COUNT(city_Id) as cnt from city_Mast where state_Id=@state_id
								) as rec_count
							);

			if @rec_count>0
			begin
				rollback transaction;
				RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
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
			
            THROW;
		end catch
	end

	if @action = 'update'
	begin
		begin try
			begin transaction

			if not EXISTS (Select 1 from user_mast where user_id = @user_id)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from state_mast where state_name = @state_name and state_id<>@state_id)
			Begin
					RAISERROR('Cannot update: state_name is already present', 16, 1);
					return;
			End
			update state_mast
			set state_name=@state_name,
				country_id=@country_id,
				created_date=@created_date,
				updated_date=@updated_date,
				user_id=@user_id
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
				 
			THROW;
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
			
			THROW;
		end catch
	end
End 
GO

