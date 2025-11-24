USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_country_mast_ins_upd_del]    Script Date: 24-11-2025 19:58:23 ******/
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
			if not EXISTS (Select 1 from user_mast where user_id = @user_id)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					print 1
					return;
			End
			if EXISTS (Select 1 from country_mast where country_name = @country_name)
			Begin
					RAISERROR('Cannot insert: country_name is already present', 16, 1);
					return;
			End
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

			THROW;
		end catch
	end

	if @action = 'select all'
	begin
		begin try
			select cm.country_id,cm.country_name,cm.created_date,cm.updated_date,um.user_name 
			from country_mast cm
			left join user_mast um on cm.user_id=um.user_id;	
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
			select cm.country_id,cm.country_name,cm.created_date,cm.updated_date,cm.user_id 
			from country_mast cm
			where cm.country_id=@country_id;
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
		declare @rec_count bigint = 0
		begin try
			begin transaction;
			set @rec_count =(
								Select sum(cnt) from 
								(
									select COUNT(country_id) as cnt from state_mast where country_id=@country_id
								) as rec_count
							);

			if @rec_count>0
			begin
				rollback transaction;
				RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
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
					print 1
					return;
			End

			if EXISTS (Select 1 from country_mast where country_name = @country_name and country_id <> @country_id)
			Begin
					RAISERROR('Cannot update: country_name is already present', 16, 1);
					return;
			End

			update country_mast
			set country_name=@country_name,
				created_date=@created_date,
				updated_date=@updated_date,
				user_id=@user_id
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
				 
			THROW;
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
				 
			THROW;
		end catch
	end

End
GO

