---1)
Select * from user_mast;
exec sp_user_mast_ins_upd_del 'insert',0,'Priya65200','Priya@652001','DB Developer',1,'2025-11-24';
exec sp_user_mast_ins_upd_del 'delete',1
exec sp_user_mast_ins_upd_del 'update',2,'Priya652002','Priya@65200','DB Developer',1,'2025-11-24';
exec sp_user_mast_ins_upd_del 'selectall'
exec sp_user_mast_ins_upd_del 'selectone',2
exec sp_user_mast_ins_upd_del 'userlist'
exec sp_user_mast_ins_upd_del 'login',0,'Priya65200','Priya@652001'

----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
---2)
Select * from country_mast;
exec sp_country_mast_ins_upd_del 'insert',0,'Germany','2025-11-24','2025-11-24',2;
exec sp_country_mast_ins_upd_del 'delete',6
exec sp_country_mast_ins_upd_del 'update',8,'India1','2025-11-24','2025-11-24',2;
exec sp_country_mast_ins_upd_del 'select all'
exec sp_country_mast_ins_upd_del 'select one',6
exec sp_country_mast_ins_upd_del 'country_mastlist'

----------------------------------------------------------------------------------------------------
---3)
Select * from state_mast;
exec sp_state_mast_ins_upd_del 'insert',0,'Karnatak',8,'2025-11-24',null,2;
exec sp_state_mast_ins_upd_del 'delete',2
exec sp_state_mast_ins_upd_del 'update',2,'Maharashtra',8,'2025-11-24',null,2;
exec sp_state_mast_ins_upd_del 'select all'
exec sp_state_mast_ins_upd_del 'select one',1
exec sp_state_mast_ins_upd_del 'state_mastlist'


----------------------------------------------------------------------------------------------------
---4)
Select * from city_mast;
exec sp_city_mast_ins_upd_del 'insert',0,'Mumbai',1,'2025-11-24',null,2;
exec sp_city_mast_ins_upd_del 'delete',2
exec sp_city_mast_ins_upd_del 'update',2,'NaviMumbai',1,'2025-11-24',null,2;
exec sp_city_mast_ins_upd_del 'select all'
exec sp_city_mast_ins_upd_del 'select one',1
exec sp_city_mast_ins_upd_del 'city_mastlist'

----------------------------------------------------------------------------------------------------
----5)
Select * from month_mast;
exec sp_month_mast_ins_upd_del 'insert',0,'December1','2025-12-01','2025-12-31','2025-11-24',null,2;
exec sp_month_mast_ins_upd_del 'delete',3
exec sp_month_mast_ins_upd_del 'update',2,'December','2025-12-01','2025-12-31','2025-11-24',null,2;
exec sp_month_mast_ins_upd_del 'select all'
exec sp_month_mast_ins_upd_del 'select one',1
exec sp_month_mast_ins_upd_del 'month_mastlist'

------------------------------------------------------------------------------------------------------
---6)
Select * from fin_year_mast;
exec sp_fin_year_mast_ins_upd_del 'insert',0,'Fin26-Fin27','F26-F27','2026-04-01','2026-03-31','2025-11-24',null,2;
exec sp_fin_year_mast_ins_upd_del 'delete',2
exec sp_fin_year_mast_ins_upd_del 'update',2,'Fin26-Fin27','F26-F27','2026-04-01','2026-03-31','2025-11-24',null,2;
exec sp_fin_year_mast_ins_upd_del 'select all'
exec sp_fin_year_mast_ins_upd_del 'select one',1
exec sp_fin_year_mast_ins_upd_del 'fin_year_mastlist'

------------------------------------------------------------------------------------------------------
----7)
Select * from employee_desg_mast;
exec sp_employee_desg_mast_ins_upd_del 'insert',0,'Full Stack Developer','Full Stack Developer',8,'2025-11-24',null,2;
exec sp_employee_desg_mast_ins_upd_del 'delete',2
exec sp_employee_desg_mast_ins_upd_del 'update',1,'DB Developer','SQL Server Developer',8,'2025-11-24',null,2;
exec sp_employee_desg_mast_ins_upd_del 'select all'
exec sp_employee_desg_mast_ins_upd_del 'select one',1
exec sp_employee_desg_mast_ins_upd_del 'employee_desg_mastlist'


------------------------------------------------------------------------------------------------------
---8)
Select * from leavetype_mast;
exec sp_leavetype_mast_ins_upd_del 'insert',0,1,24,'3 year','2 Year in Company',12,12,'2025-11-24',null,2;
exec sp_leavetype_mast_ins_upd_del 'delete',3
exec sp_leavetype_mast_ins_upd_del 'update',2,2,24,'2 year','2 Year in Company',12,12,'2025-11-24',null,2;
exec sp_leavetype_mast_ins_upd_del 'select all'
exec sp_leavetype_mast_ins_upd_del 'select one',1
exec sp_leavetype_mast_ins_upd_del 'leavetype_mastlist'

-----------------------------------------------------------------------------------------------------
---9)
Select * from errorlog;

-----------------------------------------------------------------------------------------------------
---10)
Select * from colour_mast;
exec sp_colour_mast_ins_upd_del 'insert',0,'Green',1,'2025-11-24',null,2;
exec sp_colour_mast_ins_upd_del 'delete',3
exec sp_colour_mast_ins_upd_del 'update',1,'Off White',1,'2025-11-24',null,2;
exec sp_colour_mast_ins_upd_del 'selectall'
exec sp_colour_mast_ins_upd_del 'selectone',1
exec sp_colour_mast_ins_upd_del 'colourlist'

------------------------------------------------------------------------------------------------------
---11)
Select * from unit_mast

exec sp_unit_mast_ins_upd_del 'insert',0,'liters1','liters1',1,'2025-11-24',null,2;
exec sp_unit_mast_ins_upd_del 'delete',3
exec sp_unit_mast_ins_upd_del 'update',2,'literss','liters',1,'2025-11-24',null,2;
exec sp_unit_mast_ins_upd_del 'selectall'
exec sp_unit_mast_ins_upd_del 'selectone',1
exec sp_unit_mast_ins_upd_del 'unitlist'

----------------------------------------------------------------------------------------------------
---12)
Select * from hsn_mast;
exec sp_hsn_mast_ins_upd_del 'insert',0,'HSN112',9,9,18,'2025-11-24',null,2;
exec sp_hsn_mast_ins_upd_del 'delete',2
exec sp_hsn_mast_ins_upd_del 'update',2,'HSN112',10,10,20,'2025-11-24',null,2;
exec sp_hsn_mast_ins_upd_del 'selectall'
exec sp_hsn_mast_ins_upd_del 'selectone',1
exec sp_hsn_mast_ins_upd_del 'hsnlist'

-----------------------------------------------------------------------------------------------------
---13)
Select * from prodtype_master;

exec sp_prodtype_mast_ins_upd_del 'insert',0,'Out Goods1','Outgo Goods1','2025-11-24',null,2;
exec sp_prodtype_mast_ins_upd_del 'delete',3
exec sp_prodtype_mast_ins_upd_del 'update',2,'Out Goods','Outgoo Goods','2025-11-24',null,2;
exec sp_prodtype_mast_ins_upd_del 'selectall'
exec sp_prodtype_mast_ins_upd_del 'selectone',1
exec sp_prodtype_mast_ins_upd_del 'prodtypelist'

---------------------------------------------------------------------------------------------------
---14)
Select * from brand_mast;

exec sp_brand_mast_ins_upd_del 'insert',0,'Furnich well1','Furnich well','2025-11-24',null,2;
exec sp_brand_mast_ins_upd_del 'delete',3
exec sp_brand_mast_ins_upd_del 'update',2,'Furnich well','Furnich well','2025-11-24',null,2;
exec sp_brand_mast_ins_upd_del 'selectall'
exec sp_brand_mast_ins_upd_del 'selectone',1
exec sp_brand_mast_ins_upd_del 'brandlist'

----------------------------------------------------------------------------------------------------
---15)
Select * from paytype_mast;

exec sp_paytype_mast_ins_upd_del 'insert',0,'UPI1','Online Transaction','2025-11-24',null,2;
exec sp_paytype_mast_ins_upd_del 'delete',4
exec sp_paytype_mast_ins_upd_del 'update',4,'UPI11','Online Transaction','2025-11-24',null,2;
exec sp_paytype_mast_ins_upd_del 'selectall'
exec sp_paytype_mast_ins_upd_del 'selectone',1
exec sp_paytype_mast_ins_upd_del 'paytypelist'

-----------------------------------------------------------------------------------------------------
---16)
Select * from trans_type_mast;

exec sp_trans_type_mast_ins_upd_del 'insert',0,'Receipt1','You receive money from customer','2025-11-24',null,2;
exec sp_trans_type_mast_ins_upd_del 'delete',3
exec sp_trans_type_mast_ins_upd_del 'update',1,'Payment','You pay money to vendore Transaction','2025-11-24',null,2;
exec sp_trans_type_mast_ins_upd_del 'select all';
exec sp_trans_type_mast_ins_upd_del 'select one',1;
exec sp_trans_type_mast_ins_upd_del 'trans_type_mastlist';

------------------------------------------------------------------------------------------------------
---17)
Select * from company_mast;

exec sp_company_mast_ins_upd_del 'insert',0,'CP3451','Dhara Pvd Limited1','CSShara','Private','Dhara Pvt limited','C5676','GST5676','PAN5676','Priyanka Ayyanagoudar','Priyanka@gmail.com','9878987687','Pune-411046','Katraj kondwa road',1,'411046',1,'2025-11-24',null,'C://file',2;
exec sp_company_mast_ins_upd_del 'delete',2
exec sp_company_mast_ins_upd_del 'update',2,'CP3452','Dhara Pvd Limited1','CSShara','Private','Dhara Pvt limited','C5676','GST5676','PAN5676','Priyanka Ayyanagoudar','Priyanka@gmail.com','9878987687','Pune-411046','Katraj kondwa road',1,'411046',1,'2025-11-24',null,'C://file',2;
exec sp_company_mast_ins_upd_del 'selectall';
exec sp_company_mast_ins_upd_del 'select one',1;
exec sp_company_mast_ins_upd_del 'companylist';

-------------------------------------------------------------------------------------------------------
---18)
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
---19)
Select * from user_details;
exec sp_user_details_ins_upd_del 'insert',0,2,1,3,1,'2025-11-24',null,2;
exec sp_user_details_ins_upd_del 'delete',4;
exec sp_user_details_ins_upd_del 'update',4,2,1,1,'2025-11-24',null,2;
exec sp_user_details_ins_upd_del 'selectall';
exec sp_user_details_ins_upd_del 'selectone',2,1,1;

------------------------------------------------------------------------------------------------------
----20)
Select * from product_mast;
Select * from prodtype_master;
Select * from brand_mast;
Select * from hsn_mast;
Select * from unit_mast;

exec sp_product_mast_ins_upd_del 'insert',0,1,1,1,1,'Paintnwe','Asain Paints',500,'2025-11-24',null,2;
exec sp_product_mast_ins_upd_del 'delete',3;
exec sp_product_mast_ins_upd_del 'update',1,1,1,1,1,'Wodden Tables','Furnished Table',1000,'2025-11-24',null,2;
exec sp_product_mast_ins_upd_del 'selectall';
exec sp_product_mast_ins_upd_del 'selectone',2,1,1;
exec sp_product_mast_ins_upd_del 'productlist',2,1,1;
 
---------------------------------------------------------------------------------------------------

---21)
Select * from product_details
Select * from fin_year_mast;
Select * from company_mast;
Select * from product_mast;
/*Alter table product_details
drop column current_stock;
ALTER TABLE product_details
ADD current_stock AS ((opening_stock + purchase) - (sales + [return]));*/

exec sp_product_details_ins_upd_del 'insert',0,2,0,0,0,0,0,10,'less than 5','2025-11-25',null,1,1,2;
exec sp_product_details_ins_upd_del 'delete',2;
exec sp_product_details_ins_upd_del 'update',1,1,0,0,0,0,0,5,'less than or equal to 5','2025-11-25',null,1,1,2;;
exec sp_product_details_ins_upd_del 'selectall',1;
exec sp_product_details_ins_upd_del 'selectone',1;

------------------------------------------------------------------------------------------------------------
---22)
Select * from vendor_mast;
exec sp_vendor_mast_ins_upd_del 'insert',0,'Rajveer Tupe','RP','Male','9678454433',1,'amanora town,Pune','Rajveer@gmail.com','2009-09-30','AD8668','LC668','PAN8668','GST6687',1,'None','2025-11-25',null,2;
exec sp_vendor_mast_ins_upd_del 'delete',2;
exec sp_vendor_mast_ins_upd_del 'update',2,'Rajveer Tupe','RT','Male','9678454433',1,'amanora town,Pune','Rajveer@gmail.com','2009-09-30','AD8668','LC668','PAN8668','GST6687',1,'None','2025-11-25',null,2;
exec sp_vendor_mast_ins_upd_del 'select all',1;
exec sp_vendor_mast_ins_upd_del 'select one',1;
exec sp_vendor_mast_ins_upd_del 'vendor_mastlist'

-----------------------------------------------------------------------------------------------------
---23)
Select * from customer_mast;
exec sp_customer_mast_ins_upd_del 'insert',0,'Bnand Ayyanagoudar','AA','Male','667876567
',1,'Katraj Kondhwa road,Pune','Anand@gmail.com','2000-09-30','AD8667','LC8667','PAN8667',
'GST6687',1,'None','2025-11-25',null,2;
exec sp_customer_mast_ins_upd_del 'delete',4;
exec sp_customer_mast_ins_upd_del 'update',3,'Anand Ayyanagoudar','AA','Male','667876567
',1,'Katraj Kondhwa road,Pune','AnandA@gmail.com','2002-12-25','AD8667','LC8667','PAN8667',
'GST6687',1,'None','2025-11-25',null,2;
exec sp_customer_mast_ins_upd_del 'selectall',1;
exec sp_customer_mast_ins_upd_del 'selectone',2;
exec sp_customer_mast_ins_upd_del 'customerlist'

----------------------------------------------------------------------------------------------------------
Select * from fin_year_mast;
Select * from company_mast;
Select * from customer_mast
Select * from customer_details;
Select * from inward_mast;
Select * from inward_return;
Select * from salesinvoice_mast;
Select * from salesinvoicedetails;
Select * from receipt_mast;
Select * from receipt_details

---delete from customer_details;
---24)
insert into customer_details(customer_id,opening_balance,Invoice_balance,Outstanding_balance,
created_date,updated_date,fin_year_id,comp_id,user_id)
values(2,0,3000,1000,null,null,1,1,2);
Select * from fin_year_mast;
insert into fin_year_mast(fin_name,short_fin_year,year_start,year_end,created_date,updated_date,user_id)
values('Fin26-Fin27','F26-F27','2026-04-01','2027-03-31','2025-11-27',null,2);

/*declare @pre_Outstandinginvoice decimal(12,2);
WITH cte AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY fin_year_id) AS rn
    FROM customer_details
    WHERE customer_id = 2 and 
	comp_id=1	  
)
SELECT c2.*,c1.*
FROM cte c1
JOIN cte c2 ON c2.rn = c1.rn - 1
--WHERE c1.fin_year_id = 3;

print @pre_Outstandinginvoice;*/
---delete from customer_details;
Select * from customer_details;
exec sp_customer_details_ins_upd_del 'insert',0,2,1000,0,0,'2025-11-25',null,3,1,2;
exec sp_customer_details_ins_upd_del 'delete',17;
exec sp_customer_details_ins_upd_del 'update',18,2,0,500,0,'2025-11-25','2025-11-29',3,1,2;
exec sp_customer_details_ins_upd_del 'selectall',1;
exec sp_customer_details_ins_upd_del 'selectone',17;


----------------------------------------------------------------------------------------------------
Select * from fin_year_mast;
Select * from company_mast;
Select * from vendor_mast
Select * from vendor_details;
Select * from purchaseinvoice_mast;
Select * from purchaseinvoice_details;
Select * from payment_mast;
Select * from payment_details









------------------------------------------------------------------------------------------------------
----25)
Select * from vendor_mast;
Select * from fin_year_mast;
Select * from company_mast;
Select * from vendor_details;

exec sp_vendor_details_ins_upd_del 'insert',0,1,0,0,0,'2025-11-25',null,3,1,2;
exec sp_vendor_details_ins_upd_del 'delete',4;
exec sp_vendor_details_ins_upd_del 'update',5,1,500,0,0,'2025-11-25','2025-11-29',3,1,2;
exec sp_vendor_details_ins_upd_del 'selectall',1;
exec sp_vendor_details_ins_upd_del 'selectone',17;

-------------------------------------------------------------------------------------------------------
----26)
Select * from employee_desg_mast;
Select * from city_mast;
Select * from fin_year_mast;
Select * from company_mast;
Select * from employee_mast;
exec sp_employee_mast_ins_upd_del 'insert',0,1,'Anand','Ayyanagoudar','Male','2002-12-26','9673865200','anand@gmail.com','katraj kondwa road,pune',1,'A00002','P00002','BA-00002','4567','2025-11-25',null,'BTech',2,700000,1,'2025-11-25',null,3,1,2;
exec sp_employee_mast_ins_upd_del 'delete',2;
exec sp_employee_mast_ins_upd_del 'update',3,1,'Anand','Ayyanagoudar','Male','2002-12-26','9270045689','anand@gmail.com','katraj kondwa road,pune',1,'A00002','P00002','BA-00002','4567','2025-11-25',null,'BTech',2,700000,1,'2025-11-25',null,3,1,2;
exec sp_employee_mast_ins_upd_del 'select all',1;
exec sp_employee_mast_ins_upd_del 'select one',1;
exec sp_employee_mast_ins_upd_del 'employee_mastlist',17;

--------------------------------------------------------------------------------------------------------
---27)
Select * from customer_mast;
Select * from product_mast;
Select * from fin_year_mast;
Select * from company_mast;
Select * from inward_mast;

exec sp_inward_mast_ins_upd_del 'insert',0,2,1,10,0,1,'Done',3,1,'2025-11-25',null,2;
exec sp_inward_mast_ins_upd_del 'delete',2;
exec sp_inward_mast_ins_upd_del 'update',2,2,1,10,0,1,'Done',3,1,'2025-11-25',null,2;
exec sp_inward_mast_ins_upd_del 'selectall',1;
exec sp_inward_mast_ins_upd_del 'selectone',1;
--exec sp_inward_mast_ins_upd_del 'employee_mastlist',17;

--------------------------------------------------------------------------------------------------------
---28)
Select * from customer_mast;
Select * from product_mast;
Select * from product_details;
Select * from fin_year_mast;
Select * from company_mast;
Select * from inward_mast;
Select * from inward_return;

---return 2
exec sp_inward_return_ins_upd_del 'insert',0,1,2,1,2,'Done',3,1,'2025-11-25',null,2;
exec sp_inward_return_ins_upd_del 'delete',1;
exec sp_inward_return_ins_upd_del 'update',2,1,2,1,3,'Done',3,1,'2025-11-25',null,2;
exec sp_inward_return_ins_upd_del 'selectall',1;
exec sp_inward_return_ins_upd_del 'selectone',1;


-----------------------------------------------------------------------------------------------------
Select * from customer_mast;
Select * from fin_year_mast;
Select * from company_mast;
Select * from product_details;
Select * from customer_details;
Select * from vendor_details;
---29)
Select * from salesinvoice_mast;
exec sp_salesinvoice_mast_ins_upd_del 'insert',0,'PR1','SUF1',2,'2025-11-29',0,0,0,0,0,0,0,0,0,1,3,1,'2025-11-29',null,2;
exec sp_salesinvoice_mast_ins_upd_del 'delete',4;
exec sp_salesinvoice_mast_ins_upd_del 'update',5,'PR1','SUF11',2,'2025-11-29',1,0,0,0,0,0,0,0,0,1,3,1,'2025-11-29','2025-11-29',2;
exec sp_salesinvoice_mast_ins_upd_del 'selectall',1;
exec sp_salesinvoice_mast_ins_upd_del 'selectone',3;

-----------------------------------------------------------------------------------------------------
---30)
Select * from hsn_mast;
Select * from product_mast;
Select * from colour_mast;
Select * from unit_mast;
Select * from fin_year_mast;
Select * from company_mast;
Select * from user_mast;
Select * from salesinvoicedetails;
Select * from salesinvoice_mast;
Select * from customer_details;
Select * from product_details;
Select * from inward_mast;


exec sp_salesinvoicedetails_ins_upd_del 'insert',0,5,1,1,1,1,2,2,2,0,0,0.05,0,3,0,0,0,0,0,0,0,0,0,0,3,1,'2025-11-29',null,2;
exec sp_salesinvoicedetails_ins_upd_del 'delete',13;
exec sp_salesinvoicedetails_ins_upd_del 'update',14,5,1,1,1,1,2,2,2,0,0,0.05,0,1,0,0,0,0,0,0,0,0,0,0,3,1,'2025-11-29',null,2;
exec sp_salesinvoicedetails_ins_upd_del 'selectall',1;
exec sp_salesinvoicedetails_ins_upd_del 'selectone',3;

-----------------------------------------------------------------------------------------------------
---31)
Select * from salesinvoice_mast;
Select * from challan_mast

exec sp_challan_mast_ins_upd_del 'insert',0,5,3,1,'2025-11-29',null,2;
exec sp_challan_mast_ins_upd_del 'delete',2;
exec sp_challan_mast_ins_upd_del 'update',2,3,3,1,'2025-11-29','2025-11-30',2;
exec sp_challan_mast_ins_upd_del 'selectall',1;
exec sp_challan_mast_ins_upd_del 'selectone',2;

-----------------------------------------------------------------------------------------------------
---32)
Select * from fin_year_mast;
Select * from company_mast;
Select * from user_mast;
Select * from customer_details;
Select * from product_details;
Select * from inward_mast;
Select * from salesinvoice_mast;
Select * from salesinvoicedetails;
Select * from receipt_mast
---delete check one more time
exec sp_receipt_mast_ins_upd_del 'insert',0,5,2,'2025-11-30',0,500,0,0,3,1,'2025-11-29',null,2;
exec sp_receipt_mast_ins_upd_del 'delete',19;
exec sp_receipt_mast_ins_upd_del 'update',20,5,2,'2025-11-30',0,400,0,0,3,1,'2025-11-29','2025-11-29',2;;
exec sp_receipt_mast_ins_upd_del 'selectall',1;
exec sp_receipt_mast_ins_upd_del 'selectone',2;

/*Update customer_details
set opening_balance = 1000
where customer_id=2 and fin_year_id=3 and comp_id=1;*/

-----------------------------------------------------------------------------------------------------
---33)
Select * from customer_mast;
Select * from paytype_mast;
Select * from trans_type_mast;
Select * from fin_year_mast;
Select * from company_mast;
Select * from customer_details;
Select * from salesinvoice_mast;
Select * from salesinvoicedetails;
Select * from receipt_mast;
Select * from receipt_details

---receipt_dtl_id	receipt_id	paytype_id	trans_type_id	total_amt	cheque_number	cheque_bankname	ifsc_code	cheque_date	account_number	transaction_id	card_number	transaction_date	fin_year_id	comp_id	created_date	updated_date	user_id

exec sp_receipt_details_ins_upd_del 'insert',0,20,1,1,72,'CK12345678','SBI','4567','2025-12-02','A12345678','TR1234567','1234','2025-12-02',3,1,'2025-11-29',null,2;
exec sp_receipt_details_ins_upd_del 'delete',4;
exec sp_receipt_details_ins_upd_del 'update',5,20,1,1,100,'CK12345678','SBI','4567','2025-12-02','A12345678','TR1234567','1234','2025-12-02',3,1,'2025-11-29',null,2;
exec sp_receipt_details_ins_upd_del 'selectall',1;
exec sp_receipt_details_ins_upd_del 'selectone',3;

-----------------------------------------------------------------------------------------------------
---34)
Select * from vendor_mast;
Select * from fin_year_mast;
Select * from company_mast;
Select * from user_mast;
Select * from customer_details;
Select * from vendor_details;
Select * from purchaseinvoice_mast;
Select * from salesinvoice_mast;
Select * from payment_mast;
Select * from payment_details;

exec sp_purchaseinvoice_mast_ins_upd_del 'insert',0,'P1234','S1234','INV1234','2025-12-03',1,0,0,0,0,0,0,0,0,0,1,3,1,'2025-11-29',null,2;
exec sp_purchaseinvoice_mast_ins_upd_del 'delete',1;
exec sp_purchaseinvoice_mast_ins_upd_del 'update',2,'P1234','S1234','INV1234','2025-12-03',1,0,0,0,0,0,0,0,0,0,1,3,1,'2025-11-29','2025-11-29',2;
exec sp_purchaseinvoice_mast_ins_upd_del 'select all',1;
exec sp_purchaseinvoice_mast_ins_upd_del 'select one',2;


----------------------------------------------------------------------------------------------------
---35)
Select * from customer_details;
Select * from salesinvoice_mast;
Select * from vendor_mast;
Select * from fin_year_mast;
Select * from company_mast;
Select * from user_mast;
Select * from hsn_mast;
Select * from product_mast;
Select * from product_details;
Select * from colour_mast;
Select * from unit_mast;
Select * from payment_mast;
Select * from payment_details;
Select * from vendor_details;
Select * from purchaseinvoice_mast;
Select * from purchaseinvoice_details;

exec sp_purchaseinvoice_details_ins_upd_del 'insert',0,2,2,1,1,12,12,12,0,0,1,0,0,6,0,0,0,0,0,0,0,0,0,'2025-12-03',null,3,1,2;
exec sp_purchaseinvoice_details_ins_upd_del 'delete',1;
exec sp_purchaseinvoice_details_ins_upd_del 'update',3,2,2,1,1,12,12,12,0,0,1,0,0,5,0,0,0,0,0,0,0,0,0,'2025-12-03','2025-12-03',3,1,2;
exec sp_purchaseinvoice_details_ins_upd_del 'select all',1;
exec sp_purchaseinvoice_details_ins_upd_del 'select one',3;
----------------------------------------------------------------------------------------------------------

---36)
Select * from product_mast;
Select * from product_details;
Select * from dailyconsumption_mast;

exec sp_dailyconsumption_mast_ins_upd_del 'insert',0,'2025-12-03',2,1,2,'for tables',3,1,'2025-12-03',null,2;
exec sp_dailyconsumption_mast_ins_upd_del 'delete',1;
exec sp_dailyconsumption_mast_ins_upd_del 'update',2,'2025-12-03',2,1,3,'for tables',3,1,'2025-12-03',null,2;
exec sp_dailyconsumption_mast_ins_upd_del 'select all',1;
exec sp_dailyconsumption_mast_ins_upd_del 'select one',1;

-----------------------------------------------------------------------------------------------------
---37)
Select * from fin_year_mast;
Select * from company_mast;
Select * from month_mast;
Select * from user_mast;
Select * from leavetype_mast;
Select * from employee_mast;
Select * from emp_leave_mast;

/*update leavetype_mast
set allocated_leaves=24,
casual_leaves=12,
sick_leaves=12
where leavetype_id=2;*/

exec sp_emp_leave_mast_ins_upd_del 'insert',0,1,1,3,1,'2025-12-03',1,0,0,0,'2025-11-29',null,2;
exec sp_emp_leave_mast_ins_upd_del 'delete',1;
exec sp_emp_leave_mast_ins_upd_del 'update',2,1,1,3,1,'2025-12-03',2,0,0,0,'2025-11-29','2025-11-29',2;
exec sp_emp_leave_mast_ins_upd_del 'select all',1;
exec sp_emp_leave_mast_ins_upd_del 'select one',1;

-----------------------------------------------------------------------------------------------------
---38)
Select * from employee_payslip;

exec sp_emp_leave_mast_ins_upd_del 'insert',0,1,1,3,1,'2025-12-03',1,0,0,0,'2025-11-29',null,2;
exec sp_emp_leave_mast_ins_upd_del 'delete',1;
exec sp_emp_leave_mast_ins_upd_del 'update',2,1,1,3,1,'2025-12-03',2,0,0,0,'2025-11-29','2025-11-29',2;
exec sp_emp_leave_mast_ins_upd_del 'select all',1;
exec sp_emp_leave_mast_ins_upd_del 'select one',1;

----------------------------------------------------------------------------------------------------
----39)
Select * from payment_mast;

-------------------------------------------------------------------------------------------------------
---40)
Select * from payment_details;


-------------------------------------------------------------------------------------------------------













