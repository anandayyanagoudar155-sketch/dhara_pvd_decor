USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_user_register]    Script Date: 03-12-2025 18:27:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_user_register] 
    @action nvarchar(50),
    @user_name nvarchar(200),
    @user_password nvarchar(200),
    @user_role nvarchar(50) = null,
    @comp_id bigint = 0,
    @finyear_id bigint = 0
as
begin

    declare @errornumber int,
            @errorprocedure nvarchar(200),
            @errorline int,
            @errormessage nvarchar(200);

    begin try
        begin transaction;

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

            insert into user_details (user_id, comp_id, fin_year_id, is_active, created_date, updated_date, modified_by)
            values (@new_user_id, @comp_id, @finyear_id, 1, getdate(), getdate(), @new_user_id);

        end;



        if (@action = 'login')
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
              and um.user_password = @user_password;
        end;

				update user_mast
		set is_login=1
			where user_name=@user_name and user_password=@user_password;

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

