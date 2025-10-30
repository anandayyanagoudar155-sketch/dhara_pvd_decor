Alter table brand_mast
Alter column brand_desc varchar(max);

EXEC sp_rename 'city_Mast', 'city_mast';
EXEC sp_rename 'city_Mast.city_Id', 'city_id', 'COLUMN';
EXEC sp_rename 'city_Mast.city_Name', 'city_name', 'COLUMN';
EXEC sp_rename 'city_Mast.state_Id', 'state_id', 'COLUMN';

Alter table company_mast
Alter column comp_Desc varchar(max);

EXEC sp_rename 'company_mast.comp_Desc', 'comp_desc', 'COLUMN';
EXEC sp_rename 'company_mast.conatact_phone', 'contact_phone', 'COLUMN';
EXEC sp_rename 'company_mast.is_Active', 'is_active', 'COLUMN';
