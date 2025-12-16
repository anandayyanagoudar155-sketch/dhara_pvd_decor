USE [DharaPvdDecor_Db_new_1121]
GO

/****** Object:  StoredProcedure [dbo].[sp_trans_type_mast_ins_upd_del]    Script Date: 16-12-2025 14:00:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE procedure [dbo].[sp_trans_type_mast_ins_upd_del]
(
@action varchar(max) = '',
@trans_id bigint = 0,
@transtype_name varchar(100) = '',
@transtype_desc varchar(max) = '',
@created_date date = null,
@updated_date date = null,
@created_by bigint = 0,
@modified_by bigint = 0
)
as
BEGIN
declare @errornumber int, @errorprocedure nvarchar(128), @errorline int, @errormessage nvarchar(max);
	if @action = 'insert'
	begin
		begin try
			begin transaction
			if not EXISTS (Select 1 from user_mast where user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from trans_type_mast where transtype_name = @transtype_name)
			Begin
					RAISERROR('Cannot insert: transtype_name is already present', 16, 1);
					return;
			End
			insert into trans_type_mast(transtype_name,transtype_desc,created_date,updated_date,created_by,modified_by)
			values(@transtype_name,@transtype_desc,@created_date,@updated_date,@created_by,@modified_by);
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
			Select ttm.trans_id,ttm.transtype_name,ttm.transtype_desc,ttm.created_date,ttm.updated_date,
			um.user_name
			from trans_type_mast ttm
			left join user_mast um on ttm.created_by = um.user_id;
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
			Select ttm.trans_id,ttm.transtype_name,ttm.transtype_desc,ttm.created_date,ttm.updated_date,
			ttm.created_by,ttm.modified_by
			from trans_type_mast ttm
			where ttm.trans_id = @trans_id;
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
	declare @rec_count bigint;
		begin try
			begin transaction
			set @rec_count = (
								Select sum(cnt) from
								(
									Select count(trans_id) as cnt from payment_mast where trans_id = @trans_id
									union all
									Select count(pay_type_id) as cnt from payment_details where pay_type_id = @trans_id
								) as rec_count
							 );
			if @rec_count > 0
			begin
				rollback transaction;
				RAISERROR('Cannot delete: This record is linked with other tables.', 16, 1);
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

			THROW;
		end catch
	end
	if @action = 'update'
	begin
		begin try
			begin transaction
			if not EXISTS (Select 1 from user_mast where user_id = @created_by or user_id = @modified_by)
			Begin
					RAISERROR('Cannot insert: user_id is incorrect', 16, 1);
					return;
			End
			if EXISTS (Select 1 from trans_type_mast where transtype_name = @transtype_name and trans_id <> @trans_id)
			Begin
					RAISERROR('Cannot insert: transtype_name is already present', 16, 1);
					return;
			End
			update trans_type_mast
			set transtype_name = @transtype_name,
				transtype_desc = @transtype_desc,
				created_date = @created_date,
				updated_date = @updated_date,
				created_by = @created_by,
				modified_by = @modified_by
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

			THROW;
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

			THROW;
		end catch
	end
END
GO

