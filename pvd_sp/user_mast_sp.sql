create procedure sp_user_mast_ins_upd_del(
@action varchar(max),
@user_id bigint=0,
@user_name varchar(100)='',
@user_password varchar(100)='',
@user_role varchar(50)='',
@is_login bit=0,
@created_date date=null,
@updated_date date=null
)
as
begin

declare @ErrorNumber int, @ErrorProcedure nvarchar(128), @ErrorLine int, @ErrorMessage nvarchar(max);

if @action='insert'
begin
	begin try
		begin transaction
			insert into user_mast(user_name,user_password,user_role,is_login,created_date,updated_date)
			values(@user_name,@user_password,@user_role,@is_login,@created_date,@updated_date);
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
		end catch
end



if @action='delete'
begin	
		declare @rec_count bigint
	begin try
		begin transaction;
		set @rec_count = (select sum(cnt)
			from (
			select count(user_id) as cnt from customer_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from product_mast where user_id = @user_id
			union all
			select count(user_id) as cnt from inward_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from inward_return where user_id = @user_id
			union all			
			select count(user_id) as cnt from salesinvoice_mast where user_id = @user_id
			union all			
            select count(user_id) as cnt from salesinvoicedetails where user_id = @user_id
			union all			
			select count(user_id) as cnt from challan_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from receipt_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from receipt_details where user_id = @user_id 
			union all			
			select count(user_id) as cnt from user_details where user_id = @user_id
			union all			
			select count(user_id) as cnt from company_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from colour_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from unit_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from hsn_mast where user_id = @user_id
			union all
			select count(user_id) as cnt from prodtype_master where user_id = @user_id
			union all			
            select count(user_id) as cnt from brand_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from paytype_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from vendor_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from purchaseinvoice_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from PurchaseInvoice_Details where user_id = @user_id
			union all			
            select count(user_id) as cnt from trans_type_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from dailyconsumption_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from employee_desg_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from employee_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from leavetype_mast where user_id = @user_id
			union all
            select count(user_id) as cnt from emp_leave_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from employee_payslip where user_id = @user_id
			union all			
			select count(user_id) as cnt from payment_mast where user_id = @user_id
			union all
			select count(user_id) as cnt from payment_details where user_id = @user_id
			union all			
			select count(user_id) as cnt from country_mast where user_id = @user_id
			union all			
            select count(user_id) as cnt from state_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from city_Mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from month_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from fin_year_mast where user_id = @user_id
			union all			
			select count(user_id) as cnt from emp_calenderdays where user_id = @user_id		
		) as rec_count);
		
		if @rec_count > 0
			begin
				rollback transaction;
				return;
			end
			
		delete from user_mast where user_id=@user_id;
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
			@ErrorMessage			
		end catch
end




if @action='update'
begin
	begin try
		begin transaction
			update user_mast
			set
			user_name=@user_name,
			user_password=@user_password,
			user_role=@user_role,
			is_login=@is_login,
			created_date=@created_date,
			updated_date=@updated_date
			where user_id=@user_id;

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
			@ErrorMessage			
		end catch
end



if @action='selectall'
begin
	begin try
	
		select
		user_id,
		user_name,
		user_password,
		user_role,
		is_login,
		created_date,
		updated_date
		from user_mast;
		
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
			@ErrorMessage
		end catch
end



if @action='selectone'
begin
	begin try

		select
		user_id,
		user_name,
		user_password,
		user_role,
		is_login,
		created_date,
		updated_date
		from user_mast where user_id=@user_id
					
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
			@ErrorMessage
		end catch
end



if @action='userlist'
begin
	begin try
		select
		user_id,
		user_name
		from user_mast;
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
			@ErrorMessage
		end catch
end


end
