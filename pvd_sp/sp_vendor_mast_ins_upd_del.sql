USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_vendor_mast_ins_upd_del]    Script Date: 31-10-2025 16:48:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[sp_vendor_mast_ins_upd_del]
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
@user_id bigint = 0
)
as
BEGIN
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);
	if @action = 'insert'
	begin
		begin try
			begin transaction
			insert into vendor_mast(vendor_name,prefix,gender,phonenumber,city_id,address,email_id,dob,
			aadhaar_number,license_number,pan_number,gst_number,is_active,vendor_notes,created_date,updated_date,user_id)
			values(@vendor_name,@prefix,@gender,@phonenumber,@city_id,@address,@email_id,@dob,@aadhaar_number,
			@license_number,@pan_number,@gst_number,@is_active,@vendor_notes,@created_date,@updated_date,@user_id);
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
	if @action = 'select all'
	begin
		begin try
			Select vendor_id,vendor_name,prefix,gender,phonenumber,city_id,address,email_id,dob,
			aadhaar_number,license_number,pan_number,gst_number,is_active,vendor_notes,created_date,
			updated_date,user_id
			from vendor_mast;
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
			Select vendor_id,vendor_name,prefix,gender,phonenumber,city_id,address,email_id,dob,
			aadhaar_number,license_number,pan_number,gst_number,is_active,vendor_notes,created_date,
			updated_date,user_id
			from vendor_mast
			where vendor_id = @vendor_id;
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
	declare @rec_count bigint;
		begin try
			begin transaction
			set @rec_count = (
								Select count(vendor_id) from purchaseinvoice_mast where vendor_id = @vendor_id
							 );
			If @rec_count > 0
			begin
				rollback transaction;
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
		end catch
	end
	if @action = 'update'
	begin
		begin try
			begin transaction
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
				user_id = @user_id
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
		end catch
	end
END
GO

