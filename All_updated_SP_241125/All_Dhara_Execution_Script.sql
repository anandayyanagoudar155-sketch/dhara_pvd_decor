Select * from user_mast;
exec sp_user_mast_ins_upd_del 'insert',0,'Priya65200','Priya@652001','DB Developer',1,'2025-11-24';
exec sp_user_mast_ins_upd_del 'delete',1
exec sp_user_mast_ins_upd_del 'update',2,'Priya652002','Priya@65200','DB Developer',1,'2025-11-24';
exec sp_user_mast_ins_upd_del 'selectall'
exec sp_user_mast_ins_upd_del 'selectone',2
exec sp_user_mast_ins_upd_del 'userlist'

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
Select * from country_mast;
exec sp_country_mast_ins_upd_del 'insert',0,'Germany','2025-11-24','2025-11-24',2;
exec sp_country_mast_ins_upd_del 'delete',6
exec sp_country_mast_ins_upd_del 'update',8,'India1','2025-11-24','2025-11-24',2;
exec sp_country_mast_ins_upd_del 'select all'
exec sp_country_mast_ins_upd_del 'select one',6
exec sp_country_mast_ins_upd_del 'country_mastlist'

----------------------------------------------------------------------------------------------------
Select * from state_mast;
exec sp_state_mast_ins_upd_del 'insert',0,'Karnatak',8,'2025-11-24',null,2;
exec sp_state_mast_ins_upd_del 'delete',2
exec sp_state_mast_ins_upd_del 'update',2,'Maharashtra',8,'2025-11-24',null,2;
exec sp_state_mast_ins_upd_del 'select all'
exec sp_state_mast_ins_upd_del 'select one',1
exec sp_state_mast_ins_upd_del 'state_mastlist'


----------------------------------------------------------------------------------------------------
Select * from city_mast;
exec sp_city_mast_ins_upd_del 'insert',0,'Mumbai',1,'2025-11-24',null,2;
exec sp_city_mast_ins_upd_del 'delete',2
exec sp_city_mast_ins_upd_del 'update',2,'NaviMumbai',1,'2025-11-24',null,2;
exec sp_city_mast_ins_upd_del 'select all'
exec sp_city_mast_ins_upd_del 'select one',1
exec sp_city_mast_ins_upd_del 'city_mastlist'

----------------------------------------------------------------------------------------------------
Select * from month_mast;
exec sp_month_mast_ins_upd_del 'insert',0,'December1','2025-12-01','2025-12-31','2025-11-24',null,2;
exec sp_month_mast_ins_upd_del 'delete',3
exec sp_month_mast_ins_upd_del 'update',2,'December','2025-12-01','2025-12-31','2025-11-24',null,2;
exec sp_month_mast_ins_upd_del 'select all'
exec sp_month_mast_ins_upd_del 'select one',1
exec sp_month_mast_ins_upd_del 'month_mastlist'

------------------------------------------------------------------------------------------------------
Select * from fin_year_mast;
exec sp_fin_year_mast_ins_upd_del 'insert',0,'Fin26-Fin27','F26-F27','2026-04-01','2026-03-31','2025-11-24',null,2;
exec sp_fin_year_mast_ins_upd_del 'delete',2
exec sp_fin_year_mast_ins_upd_del 'update',2,'Fin26-Fin27','F26-F27','2026-04-01','2026-03-31','2025-11-24',null,2;
exec sp_fin_year_mast_ins_upd_del 'select all'
exec sp_fin_year_mast_ins_upd_del 'select one',1
exec sp_fin_year_mast_ins_upd_del 'fin_year_mastlist'

------------------------------------------------------------------------------------------------------
Select * from employee_desg_mast;
exec sp_employee_desg_mast_ins_upd_del 'insert',0,'Full Stack Developer','Full Stack Developer',8,'2025-11-24',null,2;
exec sp_employee_desg_mast_ins_upd_del 'delete',2
exec sp_employee_desg_mast_ins_upd_del 'update',1,'DB Developer','SQL Server Developer',8,'2025-11-24',null,2;
exec sp_employee_desg_mast_ins_upd_del 'select all'
exec sp_employee_desg_mast_ins_upd_del 'select one',1
exec sp_employee_desg_mast_ins_upd_del 'employee_desg_mastlist'


------------------------------------------------------------------------------------------------------
Select * from leavetype_mast;
exec sp_leavetype_mast_ins_upd_del 'insert',0,1,24,'3 year','2 Year in Company',12,12,'2025-11-24',null,2;
exec sp_leavetype_mast_ins_upd_del 'delete',3
exec sp_leavetype_mast_ins_upd_del 'update',2,2,24,'2 year','2 Year in Company',12,12,'2025-11-24',null,2;
exec sp_leavetype_mast_ins_upd_del 'select all'
exec sp_leavetype_mast_ins_upd_del 'select one',1
exec sp_leavetype_mast_ins_upd_del 'leavetype_mastlist'

-----------------------------------------------------------------------------------------------------
Select * from errorlog;

-----------------------------------------------------------------------------------------------------
Select * from colour_mast;
exec sp_colour_mast_ins_upd_del 'insert',0,'Green',1,'2025-11-24',null,2;
exec sp_colour_mast_ins_upd_del 'delete',3
exec sp_colour_mast_ins_upd_del 'update',1,'Off White',1,'2025-11-24',null,2;
exec sp_colour_mast_ins_upd_del 'selectall'
exec sp_colour_mast_ins_upd_del 'selectone',1
exec sp_colour_mast_ins_upd_del 'colourlist'

------------------------------------------------------------------------------------------------------
Select * from unit_mast

exec sp_unit_mast_ins_upd_del 'insert',0,'liters1','liters1',1,'2025-11-24',null,2;
exec sp_unit_mast_ins_upd_del 'delete',3
exec sp_unit_mast_ins_upd_del 'update',2,'literss','liters',1,'2025-11-24',null,2;
exec sp_unit_mast_ins_upd_del 'selectall'
exec sp_unit_mast_ins_upd_del 'selectone',1
exec sp_unit_mast_ins_upd_del 'unitlist'

----------------------------------------------------------------------------------------------------
Select * from hsn_mast;
exec sp_hsn_mast_ins_upd_del 'insert',0,'HSN112',9,9,18,'2025-11-24',null,2;
exec sp_hsn_mast_ins_upd_del 'delete',2
exec sp_hsn_mast_ins_upd_del 'update',2,'HSN112',10,10,20,'2025-11-24',null,2;
exec sp_hsn_mast_ins_upd_del 'selectall'
exec sp_hsn_mast_ins_upd_del 'selectone',1
exec sp_hsn_mast_ins_upd_del 'hsnlist'

-----------------------------------------------------------------------------------------------------
Select * from prodtype_master;

exec sp_prodtype_mast_ins_upd_del 'insert',0,'Out Goods1','Outgo Goods1','2025-11-24',null,2;
exec sp_prodtype_mast_ins_upd_del 'delete',3
exec sp_prodtype_mast_ins_upd_del 'update',2,'Out Goods','Outgoo Goods','2025-11-24',null,2;
exec sp_prodtype_mast_ins_upd_del 'selectall'
exec sp_prodtype_mast_ins_upd_del 'selectone',1
exec sp_prodtype_mast_ins_upd_del 'prodtypelist'

---------------------------------------------------------------------------------------------------
Select * from brand_mast;

exec sp_brand_mast_ins_upd_del 'insert',0,'Furnich well1','Furnich well','2025-11-24',null,2;
exec sp_brand_mast_ins_upd_del 'delete',3
exec sp_brand_mast_ins_upd_del 'update',2,'Furnich well','Furnich well','2025-11-24',null,2;
exec sp_brand_mast_ins_upd_del 'selectall'
exec sp_brand_mast_ins_upd_del 'selectone',1
exec sp_brand_mast_ins_upd_del 'brandlist'

----------------------------------------------------------------------------------------------------
Select * from paytype_mast;

exec sp_paytype_mast_ins_upd_del 'insert',0,'UPI1','Online Transaction','2025-11-24',null,2;
exec sp_paytype_mast_ins_upd_del 'delete',4
exec sp_paytype_mast_ins_upd_del 'update',4,'UPI11','Online Transaction','2025-11-24',null,2;
exec sp_paytype_mast_ins_upd_del 'selectall'
exec sp_paytype_mast_ins_upd_del 'selectone',1
exec sp_paytype_mast_ins_upd_del 'paytypelist'

-----------------------------------------------------------------------------------------------------
Select * from trans_type_mast;

exec sp_trans_type_mast_ins_upd_del 'insert',0,'Receipt1','You receive money from customer','2025-11-24',null,2;
exec sp_trans_type_mast_ins_upd_del 'delete',3
exec sp_trans_type_mast_ins_upd_del 'update',1,'Payment','You pay money to vendore Transaction','2025-11-24',null,2;
exec sp_trans_type_mast_ins_upd_del 'select all';
exec sp_trans_type_mast_ins_upd_del 'select one',1;
exec sp_trans_type_mast_ins_upd_del 'trans_type_mastlist';

------------------------------------------------------------------------------------------------------
Select * from company_mast;

exec sp_company_mast_ins_upd_del 'insert',0,'CP3451','Dhara Pvd Limited1','CSShara','Private','Dhara Pvt limited','C5676','GST5676','PAN5676','Priyanka Ayyanagoudar','Priyanka@gmail.com','9878987687','Pune-411046','Katraj kondwa road',1,'411046',1,'2025-11-24',null,'C://file',2;
exec sp_company_mast_ins_upd_del 'delete',2
exec sp_company_mast_ins_upd_del 'update',2,'CP3452','Dhara Pvd Limited1','CSShara','Private','Dhara Pvt limited','C5676','GST5676','PAN5676','Priyanka Ayyanagoudar','Priyanka@gmail.com','9878987687','Pune-411046','Katraj kondwa road',1,'411046',1,'2025-11-24',null,'C://file',2;
exec sp_company_mast_ins_upd_del 'selectall';
exec sp_company_mast_ins_upd_del 'select one',1;
exec sp_company_mast_ins_upd_del 'companylist';

-------------------------------------------------------------------------------------------------------
Select * from emp_calenderdays;
Select * from company_mast;
Select * from fin_year_mast;
Select * from month_mast;

exec sp_emp_calenderdays_ins_upd_del 'insert',0,1,1,3,31,2,8,'2025-11-24',null,2;
exec sp_emp_calenderdays_ins_upd_del 'delete',3;
exec sp_emp_calenderdays_ins_upd_del 'update',3,1,1,1,31,2,8,'2025-11-24',null,2;
exec sp_emp_calenderdays_ins_upd_del 'select all';
exec sp_emp_calenderdays_ins_upd_del 'select one',2,1,1;

-----------------------------------------------------------------------------------------------------
Select * from user_details;
exec sp_user_details_ins_upd_del 'insert',0,2,1,1,'2025-11-24',null,2;
exec sp_user_details_ins_upd_del 'delete',4;
exec sp_user_details_ins_upd_del 'update',4,2,1,1,'2025-11-24',null,2;
exec sp_user_details_ins_upd_del 'selectall';
exec sp_user_details_ins_upd_del 'selectone',2,1,1;

------------------------------------------------------------------------------------------------------









