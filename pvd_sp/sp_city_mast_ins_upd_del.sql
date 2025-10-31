USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_city_mast_ins_upd_del]    Script Date: 31-10-2025 16:39:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sp_city_mast_ins_upd_del](
@action varchar(max) = '',
@city_id bigint = 0,
@city_name varchar(100) = '',
@state_id bigint = 0,
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
			insert into city_mast(city_name,state_id,created_date,updated_date,user_id)
			values(@city_name,@state_id,@created_date,@updated_date,@user_id);
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
			select city_id,city_name,state_id,created_date,updated_date,user_id 
			from city_mast;	
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
			select city_id,city_name,state_id,created_date,updated_date,user_id 
			from city_mast
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
		set @rec_count = (Select count(city_id) from city_mast where city_id = @city_id);

		if @rec_count > 0
		begin try
			begin transaction;
			set @rec_count =(select COUNT(city_id) from company_mast where city_id=@city_id
							 union all
							 select COUNT(city_id) from customer_mast where city_id=@city_id
							 union all
							 select COUNT(city_id) from vendor_mast where city_id=@city_id
							 union all
							 select COUNT(city_id) from employee_mast where city_id=@city_id
							 );

			if @rec_count>0
			begin
				rollback transaction;
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
		end catch
	end

	if @action = 'update'
	begin
		begin try
			begin transaction
			update city_mast
			set city_name=@city_name,
				state_id=@state_id,
				updated_date=@updated_date
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
		end catch
	end
	if @action = 'city_mastlist'
	begin
		begin try
			select city_id,city_name from city_mast;
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

