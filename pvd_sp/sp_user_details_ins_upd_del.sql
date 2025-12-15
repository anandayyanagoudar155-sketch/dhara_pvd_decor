USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_user_details_ins_upd_del]    Script Date: 12/16/2025 1:17:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE proc [dbo].[sp_user_details_ins_upd_del](
@action varchar(max),
@user_details_id bigint=0,
@user_id bigint=0,
@comp_id NVARCHAR(MAX)=0,
@fin_year_id NVARCHAR(MAX)=0,
@is_active bit=0,
@created_date date=null,
@updated_date date=null,
@modified_by bigint=0
)
as
begin

declare @ErrorNumber int, @ErrorProcedure nvarchar(128), @ErrorLine int, @ErrorMessage nvarchar(max);

if @action='insert'
begin
	begin try
		begin transaction

        INSERT INTO user_details
        (user_id, comp_id, fin_year_id, is_active, created_date, updated_date, modified_by)
        VALUES
        (@user_id, @comp_id, @fin_year_id, @is_active, GETDATE(), GETDATE(), @modified_by);

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



if @action='multipleinsert'
begin
	begin try
		begin transaction

		    declare @comp table (comp_id int);

            insert into @comp (comp_id)
            select value
            from dbo.fn_split_ints(@comp_id);

            declare @finyear table (fin_year_id int);

            insert into @finyear (fin_year_id)
            select value
            from dbo.fn_split_ints(@fin_year_id);

			        -- check if any combination exists
				declare @existingCount int;
				select @existingCount = count(*)
				from @comp c
				cross join @finyear f
				join user_details ud
					on ud.user_id = @user_id
					and ud.comp_id = c.comp_id
					and ud.fin_year_id = f.fin_year_id;

				if @existingCount > 0
				begin
					raiserror('company & financial year combinations already exist for this user.', 16, 1);
					rollback transaction;
					return;
				end


            insert into user_details (
                user_id,
                comp_id,
                fin_year_id,
                is_active,
                created_date,
                updated_date,
                modified_by
            )
            select 
                @user_id,
                c.comp_id,
                f.fin_year_id,
                @is_active,
                @created_date,
                @updated_date,
                @modified_by
            from @comp c
            cross join @finyear f;

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




--if @action='multipleinsert'
--begin
--	begin try
--		begin transaction

--	INSERT INTO user_details
--	(user_id, comp_id, fin_year_id, is_active, created_date, updated_date, modified_by)
--	VALUES
--	(@user_id, @comp_id, @fin_year_id, @is_active, GETDATE(), GETDATE(), @modified_by);


--		commit transaction;
--	end try
--		begin catch
--			IF XACT_STATE() <> 0
--			rollback transaction;

--			set @ErrorNumber = ERROR_NUMBER();
--			set @ErrorProcedure = ERROR_PROCEDURE();
--			set @ErrorLine = ERROR_LINE();
--			set @ErrorMessage = ERROR_MESSAGE();

--			exec errorlog_ins 
--				 @ErrorNumber,
--				 @ErrorProcedure,
--				 @ErrorLine,
--				 @ErrorMessage;	

--			THROW;
--		end catch
--end


if @action='delete'
begin	
	begin try
		begin transaction;
			delete from user_details where user_id=@user_id;
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
			update user_details 
			set user_id=@user_id,
			comp_id=@comp_id,
			fin_year_id=@fin_year_id,
			is_active=@is_active,
			created_date=@created_date,
			updated_date=@updated_date,
			modified_by=@modified_by
			where user_details_id=@user_details_id;
			
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
		select ud.user_details_id,um.user_name,cm.comp_name,fym.fin_name,ud.is_active,ud.created_date,ud.updated_date,u_modified.user_name 
		from user_details ud
		left join company_mast cm on ud.comp_id=cm.comp_id
		left join fin_year_mast fym on ud.fin_year_id=fym.fin_year_id
		left join user_mast um on ud.user_id=um.user_id
		left join user_mast u_modified on ud.modified_by = u_modified.user_id;
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
			select user_details_id,user_id,comp_id,fin_year_id,is_active,created_date,updated_date,modified_by from user_details where user_details_id=@user_details_id;
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


if @action='selectupdateall'
begin
	begin try
			select ud.user_details_id,ud.user_id,ud.comp_id,cm.comp_name,ud.fin_year_id,fym.fin_name,ud.is_active,ud.created_date,ud.updated_date,ud.modified_by 
			from user_details ud
			left join company_mast cm on ud.comp_id=cm.comp_id
			left join fin_year_mast fym on ud.fin_year_id=fym.fin_year_id
			where ud.user_id=@user_id;
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

