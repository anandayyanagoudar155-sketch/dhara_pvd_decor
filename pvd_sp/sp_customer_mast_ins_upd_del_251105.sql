USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_customer_mast_ins_upd_del]    Script Date: 05-11-2025 20:00:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_customer_mast_ins_upd_del](
@action varchar(max),
@customer_id bigint=0 ,
@customer_name varchar(100)='',
@prefix varchar(6)='',
@gender varchar(10)='',
@phonenumber varchar(12)='',
@city_id bigint=0,
@cust_address varchar(max)='',
@email_id varchar(max)='',
@dob date=null,
@aadhaar_number varchar(15)='',
@license_number varchar(18)='',
@pan_number varchar(12)='',
@gst_number varchar(25)='',
@is_active bit=0,
@customer_notes varchar(50)='',
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
			insert into customer_mast(customer_name,prefix,gender,phonenumber,city_id,cust_address,email_id,dob,aadhaar_number,license_number,pan_number,gst_number,is_active,customer_notes,created_date,updated_date,user_id)
			values(@customer_name,@prefix,@gender,@phonenumber,@city_id,@cust_address,@email_id,@dob,@aadhaar_number,@license_number,@pan_number,@gst_number,@is_active,@customer_notes,@created_date,@updated_date,@user_id)
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
		declare @rec_count bigint
	begin try
		begin transaction;
		set @rec_count = ( select sum(cnt)
				from (
                select count(customer_id) as cnt  from inward_mast where customer_id = @customer_id
				union all
                select count(customer_id) as cnt from inward_return where customer_id = @customer_id
				union all
                select count(customer_id) as cnt from salesinvoice_mast where customer_id = @customer_id
		)as rec_count);
		
		if @rec_count > 0
		begin
			rollback transaction;
			RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
			return;
		end

		delete from customer_mast where customer_id=@customer_id
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
			update customer_mast 
			set customer_name=@customer_name,
			prefix=@prefix,
			gender=@gender,
			phonenumber=@phonenumber,
			city_id=@city_id,
			cust_address=@cust_address,
			email_id=@email_id,
			dob=@dob,
			aadhaar_number=@aadhaar_number,
			license_number=@license_number,
			pan_number=@pan_number,
			gst_number=@gst_number,
			is_active=@is_active,
			customer_notes=@customer_notes,
			created_date=@created_date,
			updated_date=@updated_date,
			user_id=@user_id
				where customer_id=@customer_id
				
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
		select 
		a.customer_id,
		a.customer_name,
		a.prefix,
		a.gender,
		a.phonenumber,
		b.city_name,
		a.cust_address,
		a.email_id,
		a.dob,
		a.aadhaar_number,
		a.license_number,pan_number,
		a.gst_number,
		a.is_active,
		a.customer_notes,
		a.created_date,
		a.updated_date,
		um.user_name 
		from customer_mast a
		left join city_mast b on a.city_id=b.city_id
		left join user_mast um on a.user_id=um.user_id;
		
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
			select customer_id,customer_name,prefix,gender,phonenumber,city_id,cust_address,email_id,dob,aadhaar_number,license_number,pan_number,gst_number,is_active,customer_notes,created_date,updated_date,user_id from customer_mast where customer_id=@customer_id
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
	
	

if @action = 'customerlist'
begin
	begin try
		select customer_id,customer_name from customer_mast;
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

