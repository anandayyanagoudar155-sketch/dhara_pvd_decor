USE [DharaPvdDecor_db]
GO

/****** Object:  StoredProcedure [dbo].[sp_trans_type_mast_ins_upd_del]    Script Date: 31-10-2025 16:47:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[sp_trans_type_mast_ins_upd_del]
(
@action varchar(max) = '',
@trans_id bigint = 0,
@transtype_name varchar(100) = '',
@transtype_desc varchar(max) = '',
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
			insert into trans_type_mast(transtype_name,transtype_desc,created_date,updated_date,user_id)
			values(@transtype_name,@transtype_desc,@created_date,@updated_date,@user_id);
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
			Select trans_id,transtype_name,transtype_desc,created_date,updated_date,user_id
			from trans_type_mast;
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
			Select trans_id,transtype_name,transtype_desc,created_date,updated_date,user_id
			from trans_type_mast
			where trans_id = @trans_id;
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
								Select count(trans_id) as trans_id from payment_mast where trans_id = @trans_id
								union all
								Select count(pay_type_id) as trans_id from payment_details where pay_type_id = @trans_id
							 );
			if @rec_count > 0
			begin
				rollback transaction;
				return;
			end
			delete from trans_type_mast where trans_id = @trans_id;
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
			update trans_type_mast
			set transtype_name = @transtype_name,
				transtype_desc = @transtype_desc,
				updated_date = @updated_date,
				user_id = @user_id
			where trans_id = @trans_id;

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
	if @action = 'trans_type_mastlist'
	begin
		begin try
			Select trans_id,transtype_name
			from trans_type_mast;
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

