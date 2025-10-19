alter procedure sp_tbl_state_mast_upsert_delete(
@action varchar(max) = '',
@state_id bigint = 0,
@state_name varchar(50) = '',
@country_id bigint = 0,
@created_date date = null,
@updated_date date = null,
@user_id bigint = 0
)
as
Begin
declare @ErrorNumber int,@ErrorProcedure nvarchar(128), @ErrorLine int,@ErrorMessage nvarchar(max);
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

			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec ErrorLog_Ins 
				 @ErrorNumber,
				 @ErrorProcedure,
				 @ErrorLine,
				 @ErrorMessage;	
		end catch
	end

	if @action = 'Select all'
	begin
		begin try
			select state_id,state_name,country_id,created_date,updated_date,user_id 
			from state_mast;	
		end try
		begin catch
			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec ErrorLog_Ins
			@ErrorNumber,
			@ErrorProcedure,
			@ErrorLine,
			@ErrorMessage
		end catch
	end

	if @action = 'Select one'
	begin
		begin try
			select state_id,state_name,country_id,created_date,updated_date,user_id 
			from state_mast
			where state_id=@state_id;
		end try
		begin catch
			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec ErrorLog_Ins
			@ErrorNumber,
			@ErrorProcedure,
			@ErrorLine,
			@ErrorMessage
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

			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec ErrorLog_Ins
			@ErrorNumber,
			@ErrorProcedure,
			@ErrorLine,
			@ErrorMessage			
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

			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec ErrorLog_Ins
			@ErrorNumber,
			@ErrorProcedure,
			@ErrorLine,
			@ErrorMessage			
		end catch
	end
	if @action = 'drop down'
	begin
		begin try
			select state_id,state_name from state_mast;
		end try
		begin catch
			
			set @ErrorNumber = ERROR_NUMBER();
			set @ErrorProcedure = ERROR_PROCEDURE();
			set @ErrorLine = ERROR_LINE();
			set @ErrorMessage = ERROR_MESSAGE();

			exec ErrorLog_Ins
			@ErrorNumber,
			@ErrorProcedure,
			@ErrorLine,
			@ErrorMessage			
		end catch
	end
End 