USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_vendor_mast_ins_upd_del]    Script Date: 16-12-2025 15:24:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE procedure [dbo].[sp_vendor_mast_ins_upd_del]
(
@action varchar(max) = '',
@vendor_id bigint = 0,
@vendor_name varchar(100) = '',
@prefix varchar(6) = '',
@gender varchar(10) = '',
@phonenumber varchar(12) = '',
@city_id bigint = 0,
@address varchar(max) = '',
@email_id varchar(max) = '',
@dob date = null,
@aadhaar_number varchar(15) = '',
@license_number varchar(18) = '',
@pan_number varchar(12) = '',
@gst_number varchar(25) = '',
@is_active bit = 0,
@vendor_notes varchar(50) = '',
@created_date date = null,
@updated_date date = null,
@created_by bigint = 0,
@modified_by bigint = 0
)
as
BEGIN
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);
	if @action = 'insert'
	begin
		begin try
			begin transaction
			if not EXISTS (Select 1 from city_mast where city_id = @city_id)
			Begin
					RAISERROR('Cannot insert: city_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from user_mast where user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from vendor_mast where vendor_name = @vendor_name)
			Begin
					RAISERROR('Cannot insert: vendor_name is already present', 16, 1);
					return;
			End
			insert into vendor_mast(vendor_name,prefix,gender,phonenumber,city_id,address,email_id,dob,
			aadhaar_number,license_number,pan_number,gst_number,is_active,vendor_notes,created_date,updated_date,created_by,modified_by)
			values(@vendor_name,@prefix,@gender,@phonenumber,@city_id,@address,@email_id,@dob,@aadhaar_number,
			@license_number,@pan_number,@gst_number,@is_active,@vendor_notes,@created_date,@updated_date,@created_by,@modified_by);
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
	if @action = 'select all'
	begin
		begin try
			Select vm.vendor_id,vm.vendor_name,vm.prefix,vm.gender,vm.phonenumber,cm.city_name,vm.address,
			vm.email_id,vm.dob,vm.aadhaar_number,vm.license_number,vm.pan_number,vm.gst_number,vm.is_active,
			vm.vendor_notes,vm.created_date,vm.updated_date,um.user_name
			from vendor_mast vm
			left join user_mast um on vm.created_by = um.user_id
			left join city_mast cm on vm.city_id = cm.city_id;
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
			Select vm.vendor_id,vm.vendor_name,vm.prefix,vm.gender,vm.phonenumber,vm.city_id,vm.address,
			vm.email_id,vm.dob,vm.aadhaar_number,vm.license_number,vm.pan_number,vm.gst_number,vm.is_active,
			vm.vendor_notes,vm.created_date,vm.updated_date,vm.created_by,vm.modified_by
			from vendor_mast vm
			where vm.vendor_id = @vendor_id;
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
	declare @rec_count bigint;
		begin try
			begin transaction
			set @rec_count = (
								Select sum(cnt) from
								(
								Select count(vendor_id) as cnt from purchaseinvoice_mast where vendor_id = @vendor_id
								) as rec_count
							 );
			If @rec_count > 0
			begin
				rollback transaction;
				RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
				return;
			end
			delete from vendor_mast where vendor_id = @vendor_id;
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
			if not EXISTS (Select 1 from city_mast where city_id = @city_id)
			Begin
					RAISERROR('Cannot insert: city_id is incorrect', 16, 1);
					return;
			End
			if not EXISTS (Select 1 from user_mast where user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from vendor_mast where vendor_name = @vendor_name and vendor_id <> @vendor_id)
			Begin
					RAISERROR('Cannot insert: vendor_name is already present', 16, 1);
					return;
			End
			update vendor_mast
			set vendor_name = @vendor_name,
				prefix = @prefix,
				gender = @gender,
				phonenumber = @phonenumber,
				city_id = @city_id,
				address = @address,
				email_id = @email_id,
				dob = @dob,
				aadhaar_number = @aadhaar_number,
				license_number = @license_number,
				pan_number = @pan_number,
				gst_number = @gst_number,
				is_active = @is_active,
				vendor_notes = @vendor_notes,
				created_date = @created_date,
				updated_date = @updated_date,
				created_by = @created_by,
				modified_by = @modified_by
			where vendor_id = @vendor_id;

			If @@ROWCOUNT = 0
			begin
				rollback transaction;
				return;
			end
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
	if @action = 'vendor_mastlist'
	begin
		begin try
			select vendor_id,vendor_name from vendor_mast;
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
END
GO

