USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_fin_year_mast_ins_upd_del]    Script Date: 31-10-2025 16:44:18 ******/
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
		end catch
	end
	if @action = 'select all'
	begin
		begin try
			select fin_year_id,fin_name,short_fin_year,year_start,year_end,created_date,updated_date,user_id
			from fin_year_mast;
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
			select fin_year_id,fin_name,short_fin_year,year_start,year_end,created_date,updated_date,user_id
			from fin_year_mast
			where fin_year_id = @fin_year_id;
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
		begin try
			 begin transaction
			 declare @rec_count bigint;

			 set @rec_count = (
								Select count(fin_year_id) from emp_calenderdays where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from inward_mast where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from inward_return where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from salesinvoice_mast where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from  salesinvoicedetails where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from challan_mast where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from receipt_mast where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from receipt_details where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from purchaseinvoice_mast where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from PurchaseInvoice_Details where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from payment_mast where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from payment_details where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from dailyconsumption_mast where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from employee_mast where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from emp_leave_mast where fin_year_id=@fin_year_id
								union all
								Select count(fin_year_id) from employee_payslip where fin_year_id=@fin_year_id 
							  );
			if @rec_count>0
			begin
				rollback transaction;
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

		end catch
	end
	if @action = 'update'
	begin
		begin try
			begin transaction;
			update fin_year_mast
			set fin_name=@fin_name,
				short_fin_year=@short_fin_year,
				year_start=@year_start,
				year_end=@year_end,
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
		end catch
	end
END
GO

