USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_company_mast_ins_upd_del]    Script Date: 03-12-2025 17:04:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[sp_company_mast_ins_upd_del](
@action varchar(max),
@comp_id bigint=0,
@comp_code varchar(25)='',
@comp_name varchar(100)='',
@comp_short_name varchar(6)='',
@comp_type varchar(50)='',
@comp_desc varchar(max)='',
@cin_number varchar(25)='',
@gst_number varchar(25)='',
@pan_number varchar(12)='',
@contperson_name varchar(100)='',
@contact_email varchar(max)='',
@contact_phone varchar(12)='',
@address_line1 varchar(max)='',
@address_line2 varchar(max)='',
@city_id bigint=0,
@pincode varchar(6)='',
@is_active bit=0,
@created_date date=null,
@updated_date date=null,
@logo_path varchar(max)='',
@user_id bigint=0
)
as
begin


declare @ErrorNumber int, @ErrorProcedure nvarchar(128), @ErrorLine int, @ErrorMessage nvarchar(max);


if @action='insert'
begin
	begin try
		begin transaction
			if not EXISTS (Select 1 from user_mast where user_id = @user_id)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from company_mast where 
					  (comp_code = @comp_code or 
					  comp_name = @comp_name or
					  comp_short_name = @comp_short_name))
			Begin
					RAISERROR('Cannot insert: comp_code/comp_name/comp_short_name is already present', 16, 1);
					return;
			End

			insert into company_mast(
			comp_code,
			comp_name,
			comp_short_name,
			comp_type,
			comp_Desc,
			cin_number,
			gst_number,
			pan_number,
			contperson_name,
			contact_email,
			contact_phone,
			address_line1,
			address_line2,
			city_id,
			pincode,
			is_active,
			created_date,
			updated_date,
			logo_path,
			user_id)

			values(
			@comp_code,
			@comp_name,
			@comp_short_name,
			@comp_type,
			@comp_Desc,
			@cin_number,
			@gst_number,
			@pan_number,
			@contperson_name,
			@contact_email,
			@contact_phone,
			@address_line1,
			@address_line2,
			@city_id,
			@pincode,
			@is_active,
			@created_date,
			@updated_date,
			@logo_path,
			@user_id
			);
			
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
            select count(comp_id) as cnt from user_details where comp_id = @comp_id
			union all
            select count(comp_id) as cnt from inward_mast where comp_id = @comp_id
			union all
            select count(comp_id) as cnt from inward_return where comp_id = @comp_id
            union all
			select count(comp_id) as cnt from salesinvoice_mast where comp_id = @comp_id
            union all
			select count(comp_id) as cnt from salesinvoicedetails where comp_id = @comp_id
            union all
			select count(comp_id) as cnt from challan_mast where comp_id = @comp_id
            union all
			select count(comp_id) as cnt from receipt_mast where comp_id = @comp_id
            union all
			select count(comp_id) as cnt from receipt_details where comp_id = @comp_id
            union all
			select count(comp_id) as cnt from purchaseinvoice_mast where comp_id = @comp_id
            union all
			select count(comp_id) as cnt from PurchaseInvoice_Details where comp_id = @comp_id
            union all
			select count(comp_id) as cnt from dailyconsumption_mast where comp_id = @comp_id
            union all
			select count(comp_id) as cnt from employee_mast where comp_id = @comp_id
            union all
			select count(company_id) as cnt from employee_payslip where company_id = @comp_id
            union all
			select count(comp_id) as cnt from payment_mast where comp_id = @comp_id
            union all
			select count(comp_id) as cnt from payment_details where comp_id = @comp_id	
		) as rec_count);
		
		if @rec_count > 0
		begin
			rollback transaction;
			RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
			return;
		end

		delete from company_mast where comp_id=@comp_id
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

			if not EXISTS (Select 1 from user_mast where user_id = @user_id)
			Begin
					RAISERROR('Cannot update: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from company_mast where 
					  (comp_code = @comp_code or 
					  comp_name = @comp_name or
					  comp_short_name = @comp_short_name) and comp_id <> @comp_id)
			Begin
					RAISERROR('Cannot update: comp_code/comp_name/comp_short_name is already present', 16, 1);
					return;
			End

			update company_mast 
			set 
			comp_code=@comp_code,
			comp_name=@comp_name,
			comp_short_name=@comp_short_name,
			comp_type=@comp_type,
			comp_Desc=@comp_Desc,
			cin_number=@cin_number,
			gst_number=@gst_number,
			pan_number=@pan_number,
			contperson_name=@contperson_name,
			contact_email=@contact_email,
			contact_phone=@contact_phone,
			address_line1=@address_line1,
			address_line2=@address_line2,
			city_id=@city_id,
			pincode=@pincode,
			is_active=@is_active,
			created_date=@created_date,
			updated_date=@updated_date,
			logo_path=@logo_path,
			user_id=@user_id
			where comp_id=@comp_id;
				
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
		cm.comp_id,
		cm.comp_code,
		cm.comp_name,
		cm.comp_short_name,
		cm.comp_type,
		cm.comp_Desc,
		cm.cin_number,
		cm.gst_number,
		cm.pan_number,
		cm.contperson_name,
		cm.contact_email,
		cm.contact_phone,
		cm.address_line1,
		cm.address_line2,
		ctm.city_name,
		cm.pincode,
		cm.is_active,
		cm.created_date,
		cm.updated_date,
		cm.logo_path,
		um.user_name 
		from company_mast cm
		left join city_mast ctm on cm.city_id=ctm.city_id
		left join user_mast um on cm.user_id=um.user_id;
		
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
		select 
		comp_id,
		comp_code,
		comp_name,
		comp_short_name,
		comp_type,
		comp_Desc,
		cin_number,
		gst_number,
		pan_number,
		contperson_name,
		contact_email,
		contact_phone,
		address_line1,
		address_line2,
		city_id,
		pincode,
		is_active,
		created_date,
		updated_date,
		logo_path,
		user_id from company_mast where comp_id=@comp_id ;
	
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



if @action='companylist'
begin
	begin try
		select comp_id,comp_name from company_mast;
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

