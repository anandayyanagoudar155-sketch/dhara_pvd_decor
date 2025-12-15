USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_user_mast_ins_upd_del]    Script Date: 12/16/2025 1:17:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_user_mast_ins_upd_del](
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
	        select count(*) as cnt from customer_mast              where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from product_mast            where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from inward_mast             where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from inward_return           where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from salesinvoice_mast       where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from salesinvoicedetails     where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from challan_mast            where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from receipt_mast            where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from receipt_details         where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from user_details            where (user_id = @user_id or modified_by = @user_id)
			union all select count(*) from company_mast            where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from colour_mast             where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from unit_mast               where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from hsn_mast                where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from prodtype_master         where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from brand_mast              where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from paytype_mast            where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from vendor_mast             where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from purchaseinvoice_mast    where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from purchaseinvoice_details where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from trans_type_mast         where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from dailyconsumption_mast   where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from employee_desg_mast      where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from employee_mast           where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from leavetype_mast          where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from emp_leave_mast          where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from employee_payslip        where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from payment_mast            where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from payment_details         where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from country_mast            where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from state_mast              where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from city_mast               where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from month_mast              where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from fin_year_mast           where (created_by = @user_id or modified_by = @user_id)
			union all select count(*) from emp_calenderdays        where (created_by = @user_id or modified_by = @user_id)
		) as rec_count);
		
		if @rec_count > 0
			begin
				rollback transaction;
				RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
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
			@ErrorMessage;
			
			THROW;
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
		from user_mast ;
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

--if @action='login'
--begin

--	select  * from user_mast		
--	where user_name=@user_name and user_password=@user_password;

--	update user_mast
--	set is_login=1
--		where user_name=@user_name and user_password=@user_password;
--end
--else
--	begin
--		return 0;
--	end


end


GO

