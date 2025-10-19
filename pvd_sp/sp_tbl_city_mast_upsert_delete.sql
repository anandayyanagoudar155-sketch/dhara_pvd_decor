create procedure sp_tbl_city_mast_upsert_delete(
@action varchar(max) = '',
@city_Id bigint = 0,
@city_name varchar(50) = '',
@state_id bigint = 0,
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
			insert into city_Mast(city_Name,state_Id,created_date,updated_date,user_id)
			values(@city_name,@state_id,@created_date,@updated_date,@user_id);
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
			select city_Id,city_Name,state_Id,created_date,updated_date,user_id 
			from city_Mast;	
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
			select city_Id,city_Name,state_Id,created_date,updated_date,user_id 
			from city_Mast
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
		set @rec_count = (Select count(city_Id) from city_Mast where city_Id = @city_Id);

		if @rec_count > 0
		begin try
			begin transaction;
			set @rec_count =(select COUNT(city_Id) from company_mast where city_Id=@city_Id
							 union all
							 select COUNT(city_Id) from customer_mast where city_Id=@city_Id
							 union all
							 select COUNT(city_Id) from vendor_mast where city_Id=@city_Id
							 union all
							 select COUNT(city_Id) from employee_mast where city_Id=@city_Id
							 );

			if @rec_count>0
			begin
				rollback transaction;
				return;
			end

			delete from city_Mast where city_Id = @city_Id;
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
			update city_Mast
			set city_Name=@city_name,
				state_Id=@state_id,
				updated_date=@updated_date
			where city_Id = @city_Id;

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
			select city_Id,city_Name from city_Mast;
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