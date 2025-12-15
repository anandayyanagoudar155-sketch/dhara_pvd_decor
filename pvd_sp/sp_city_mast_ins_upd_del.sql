USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_city_mast_ins_upd_del]    Script Date: 12/16/2025 1:16:29 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_city_mast_ins_upd_del](
@action varchar(max) = '',
@city_id bigint = 0,
@city_name varchar(100) = '',
@state_id bigint = 0,
@created_date date = null,
@updated_date date = null,
@created_by bigint = null,
@modified_by bigint = null,
@user_id bigint = 0
)
as
Begin
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);
if @action = 'insert'
	begin
		begin try
			begin transaction

			--if not EXISTS (Select 1 from user_mast where user_id = @user_id)
			--Begin
			--		RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
			--		return;
			--End
			if EXISTS (Select 1 from city_mast where city_name = @city_name)
			Begin
					RAISERROR('Cannot insert: city_name is already present', 16, 1);
					return;
			End
			insert into city_mast(city_name,state_id,created_date,updated_date,created_by,modified_by)
			values(@city_name,@state_id,@created_date,@updated_date,@created_by,@modified_by);
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

	if @action = 'selectall'
	begin
		begin try
			select cm.city_id,
			cm.city_name,
			sm.state_name,
			cm.created_date,
			cm.updated_date,
			cm.created_by,
			uc.user_name,
			cm.modified_by,
			um.user_name 
			from city_mast cm
			left join state_mast sm on cm.state_id = sm.state_id
			left join user_mast uc on cm.created_by=uc.user_id
			left join user_mast um on cm.modified_by=um.user_id;	
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

	if @action = 'selectone'
	begin
		begin try
			select cm.city_id,cm.city_name,cm.state_id,cm.created_date,cm.updated_date,cm.created_by,cm.modified_by  
			from city_mast cm
			where cm.city_id=@city_id;
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
		set @rec_count = (Select count(city_id) from city_mast where city_id = @city_id);

		if @rec_count > 0
		begin try
			begin transaction;
			set @rec_count =(
								 Select sum(cnt) from
								 (
									 select COUNT(city_id) as cnt from company_mast where city_id=@city_id
									 union all
									 select COUNT(city_id) as cnt from customer_mast where city_id=@city_id
									 union all
									 select COUNT(city_id) as cnt from vendor_mast where city_id=@city_id
									 union all
									 select COUNT(city_id) as cnt from employee_mast where city_id=@city_id
								 ) as rec_count
							 );

			if @rec_count>0
			begin
				rollback transaction;
				RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
				return;
			end

			delete from city_mast where city_id = @city_id;
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

			--if not EXISTS (Select 1 from user_mast where user_id = @user_id)
			--Begin
			--		RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
			--		return;
			--End

			if EXISTS (Select 1 from city_mast where city_name = @city_name and city_id <>@city_id)
			Begin
					RAISERROR('Cannot update: city_name is already present', 16, 1);
					return;
			End
			update city_mast
			set city_name=@city_name,
				state_id=@state_id,
				created_date=@created_date,
				updated_date=@updated_date,
				created_by=@created_by,
				modified_by=@modified_by
			where city_id = @city_id;

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
	if @action = 'city_mastlist'
	begin
		begin try
			select city_id,city_name 
			from city_mast
			where (@state_id= 0 OR state_id = @state_id);
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

