USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_fin_year_mast_ins_upd_del]    Script Date: 03-12-2025 17:20:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








CREATE procedure [dbo].[sp_fin_year_mast_ins_upd_del]
(
@action varchar(max) = '',
@fin_year_id bigint = 0,
@fin_name varchar(50) = '',
@short_fin_year varchar(10) = '',
@year_start date = null,
@year_end date = null,
@created_date date = null,
@updated_date date = null,
@user_id bigint = null
)
as
BEGIN
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);
	if @action = 'insert'
	begin
		begin try
			begin transaction
			if not EXISTS (Select 1 from user_mast where user_id = @user_id)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from fin_year_mast where fin_name = @fin_name
						or short_fin_year =@short_fin_year )
			Begin
					RAISERROR('Cannot insert: fin_name and short_fin_year is already present', 16, 1);
					return;
			End

			IF NOT (DATEPART(DAY, @year_start) = 1 AND DATEPART(MONTH, @year_start) = 4)
			BEGIN
				RAISERROR('Financial start date must be 1st April.', 16, 1);
				RETURN;
			END

			IF NOT (DATEPART(DAY, @year_end) = 31 AND DATEPART(MONTH, @year_end) = 3)
			BEGIN
				RAISERROR('Financial end date must be 31st March.', 16, 1);
				RETURN;
			END


			insert into fin_year_mast(fin_name,short_fin_year,year_start,year_end,created_date,updated_date,user_id)
			values(@fin_name,@short_fin_year,@year_start,@year_end,@created_date,@updated_date,@user_id);
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
			select fm.fin_year_id,fm.fin_name,fm.short_fin_year,fm.year_start,fm.year_end,
			fm.created_date,fm.updated_date,um.user_name
			from fin_year_mast fm
			left join user_mast um on fm.user_id = um.user_id;
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
			select fm.fin_year_id,fm.fin_name,fm.short_fin_year,fm.year_start,fm.year_end,
			fm.created_date,fm.updated_date,fm.user_id
			from fin_year_mast fm
			where fm.fin_year_id = @fin_year_id;
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
		begin try
			 begin transaction
			 declare @rec_count bigint;

			 set @rec_count = (
									Select sum(cnt) from
									(
										Select count(fin_year_id) as cnt from emp_calenderdays where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from inward_mast where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from inward_return where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from salesinvoice_mast where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from  salesinvoicedetails where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from challan_mast where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from receipt_mast where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from receipt_details where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from purchaseinvoice_mast where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from PurchaseInvoice_Details where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from payment_mast where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from payment_details where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from dailyconsumption_mast where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from employee_mast where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from emp_leave_mast where fin_year_id=@fin_year_id
										union all
										Select count(fin_year_id) as cnt from employee_payslip where fin_year_id=@fin_year_id 
								    ) as rec_count
							  );
			if @rec_count>0
			begin
				rollback transaction;
				RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
				return;
			end

			delete from fin_year_mast where fin_year_id = @fin_year_id;
			commit transaction;
		end try
		begin catch
			if XACT_STATE() <> 0
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
			begin transaction;

			if not EXISTS (Select 1 from user_mast where user_id = @user_id)
			Begin
					RAISERROR('Cannot update: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from fin_year_mast where fin_name = @fin_name
						and short_fin_year =@short_fin_year and fin_year_id <> @fin_year_id )
			Begin
					RAISERROR('Cannot update: fin_name and short_fin_year is already present', 16, 1);
					return;
			End

			IF NOT (DATEPART(DAY, @year_start) = 1 AND DATEPART(MONTH, @year_start) = 4)
			BEGIN
				RAISERROR('Financial start date must be 1st April.', 16, 1);
				RETURN;
			END

			IF NOT (DATEPART(DAY, @year_end) = 31 AND DATEPART(MONTH, @year_end) = 3)
			BEGIN
				RAISERROR('Financial end date must be 31st March.', 16, 1);
				RETURN;
			END

			update fin_year_mast
			set fin_name=@fin_name,
				short_fin_year=@short_fin_year,
				year_start=@year_start,
				year_end=@year_end,
				created_date=@created_date,
				updated_date=@updated_date,
				user_id = @user_id
			where fin_year_id = @fin_year_id;
			
			if @@ROWCOUNT = 0
			begin
				rollback transaction;
				return;
			end
			commit transaction;
		end try
		begin catch
			if XACT_STATE() <> 0
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
	if @action = 'fin_year_mastlist'
	begin
		begin try
			select fin_year_id,fin_name,short_fin_year from fin_year_mast;
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

