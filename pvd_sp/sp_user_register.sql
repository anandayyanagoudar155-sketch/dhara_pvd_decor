USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_user_register]    Script Date: 12/16/2025 1:18:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_user_register] 
    @action nvarchar(50),
    @user_name nvarchar(200),
    @user_password nvarchar(200),
    @user_role nvarchar(50) = null,
    @comp_ids NVARCHAR(MAX)=0,  
    @finyear_ids NVARCHAR(MAX)=0  
as
begin

    declare @errornumber int,
            @errorprocedure nvarchar(200),
            @errorline int,
            @errormessage nvarchar(200);

    begin try
        begin transaction;

        --if (@action = 'register')
        --begin
        --    if exists (select 1 from user_mast where user_name = @user_name)
        --    begin
        --        raiserror('username already exists', 16, 1);
        --        rollback transaction;
        --        return;
        --    end;

        --    insert into user_mast (user_name, user_password, user_role, is_login, created_date, updated_date)
        --    values (@user_name, @user_password, @user_role, 0, getdate(), getdate());

        --    declare @new_user_id int = scope_identity();

        --    insert into user_details (user_id, comp_id, fin_year_id, is_active, created_date, updated_date, modified_by)
        --    values (@new_user_id, @comp_id, @finyear_id, 1, getdate(), getdate(), @new_user_id);

        --end;


		if (@action = 'register')
		begin
			if exists (select 1 from user_mast where user_name = @user_name)
			begin
				raiserror('username already exists', 16, 1);
				rollback transaction;
				return;
			end;

			insert into user_mast (user_name, user_password, user_role, is_login, created_date, updated_date)
			values (@user_name, @user_password, @user_role, 0, getdate(), getdate());

			declare @new_user_id int = scope_identity();

			declare @companies table (comp_id int);
			declare @finyears table (fin_year_id int);

			insert into @companies (comp_id)
			select value from dbo.fn_split_ints(@comp_ids);

			insert into @finyears (fin_year_id)
			select value from dbo.fn_split_ints(@finyear_ids);

			insert into user_details (user_id, comp_id, fin_year_id, is_active, created_date, updated_date, modified_by)
			select 
				@new_user_id,
				c.comp_id,
				f.fin_year_id,
				1,
				getdate(),
				getdate(),
				@new_user_id
			from @companies c
			cross join @finyears f;
		end;


        if (@action = 'verifylogin')
        begin
            select 
                um.user_id,
                um.user_name
            from user_mast um
            where um.user_name = @user_name
              and um.user_password = @user_password;

		end;


		if (@action = 'savelogin')
        begin
            select 
                um.user_id,
                um.user_name,
                um.user_role,
                ud.comp_id,
				cm.comp_name,
                ud.fin_year_id,
				fy.fin_name,
                fy.year_start,
                fy.year_end
            from user_mast um
            inner join user_details ud
                on um.user_id = ud.user_id
			inner join company_mast cm
                on ud.comp_id = cm.comp_id
            inner join fin_year_mast fy
                on ud.fin_year_id = fy.fin_year_id
            where um.user_name = @user_name
              and um.user_password = @user_password
			  and ud.comp_id= @comp_ids
			  and ud.fin_year_id = @finyear_ids;

				update user_mast
		set is_login=1
			where user_name=@user_name and user_password=@user_password;
		end;


        commit transaction;
    end try

    begin catch
        if xact_state() <> 0
            rollback transaction;

        set @errornumber = error_number();
        set @errorprocedure = error_procedure();
        set @errorline = error_line();
        set @errormessage = error_message();

        exec errorlog_ins 
             @errornumber,
             @errorprocedure,
             @errorline,
             @errormessage;

        throw;
    end catch
end;





GO

