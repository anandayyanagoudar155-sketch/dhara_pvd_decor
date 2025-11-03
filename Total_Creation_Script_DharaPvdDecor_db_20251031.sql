create database DharaPvdDecor_db;
use DharaPvdDecor_db;

---------------------------------------------------------------

create table errorlog(
errorlogid int identity(1,1) primary key,
errornumber int,
errorprocedure nvarchar(128),
errorline int ,
errormessage nvarchar(max),
);

---------------------------------------------------------------

create table user_mast(
user_id bigint identity(1,1) primary key,
user_name varchar(100) not null unique,
user_password varchar(100) not null unique,
user_role varchar(50),
is_login bit,
created_date date,
updated_date date
);

---------------------------------------------------------------

create table country_mast(
country_id bigint identity(1,1) primary key,
country_name varchar(100) not null unique,
created_date date,
updated_date date,
user_id bigint
foreign key(user_id) references user_mast(user_id)
);

---------------------------------------------------------------

create table state_mast(
state_id bigint identity(1,1) primary key,
state_name varchar(100) not null unique ,
country_id bigint,
created_date date,
updated_date date,
user_id bigint
foreign Key(country_id) references country_mast(country_id),
foreign Key(user_id) references user_mast(user_id)
);

---------------------------------------------------------------

create table city_mast(
city_id bigint identity(1,1) primary key,
city_name varchar(100) not null unique,
state_id bigint,
created_date date,
updated_date date,
user_id bigint
foreign key(state_id) references state_mast(state_id),
foreign key(user_id) references user_mast(user_id)
);

---------------------------------------------------------------

create table company_mast(
comp_id bigint identity(1,1) primary key,
comp_code varchar(25) not null unique,
comp_name varchar(100) not null unique,
comp_short_name varchar(6) not null unique,
comp_type varchar(50),
comp_desc varchar(max),
cin_number varchar(25),
gst_number varchar(25),
pan_number varchar(12),
contperson_name varchar(100),
contact_email varchar(max),
contact_phone varchar(12),
address_line1 varchar(max),
address_line2 varchar(max),
city_id bigint,
pincode varchar(6),
is_active bit,
created_date date,
updated_date date,
logo_path varchar(max),
user_id bigint,
foreign key(city_id) references city_mast(city_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table user_details(
user_details_id bigint identity(1,1) primary key,
user_id bigint,
comp_id bigint,
is_active bit,
created_date date,
updated_date date,
modified_by bigint
foreign key(user_id) references User_Mast(user_id),
foreign key(comp_id) references Company_Mast(comp_id),
foreign key(modified_by) references User_Mast(user_id)
)

---------------------------------------------------------------

create table month_mast(
month_id bigint identity(1,1) primary key,
month_name varchar(50) not null,
[start_date] date,
end_date date,
created_date date,
updated_date date,
user_id bigint
foreign key(user_id) references user_mast(user_id)
);

---------------------------------------------------------------


create table fin_year_mast(
fin_year_id bigint identity(1,1) primary key,
fin_name varchar(50) not null unique,
short_fin_year varchar(10),
year_start date,
year_end date,
created_date date,
updated_date date,
user_id bigint
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table emp_calenderdays(
emp_calender_id bigint identity(1,1) primary key,
fin_year_id bigint,
month_id bigint,
month_days decimal(5,2),
emp_holidays decimal(5,2),
emp_weekend decimal(5,2),
created_date date,
updated_date date,
user_id bigint
foreign key(fin_year_id) references fin_year_mast(fin_year_id),
foreign key(month_id) references month_mast(month_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table colour_mast(
colour_id bigint identity(1,1) primary key,
colour_name varchar(50) not null unique,
is_active bit,
created_date date,
updated_date date,
user_id bigint
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table unit_mast(
unit_id bigint identity(1,1) primary key,
unit_name varchar(50) not null unique,
unit_desc varchar(max),
is_active bit,
created_date date,
updated_date date,
user_id bigint
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------


create table hsn_mast(
hsn_id bigint identity(1,1) primary key,
hsn_code varchar(10) unique,
cgst_perc decimal(5,2),
sgst_perc decimal(5,2),
igst_perc decimal(5,2),
created_date date,
updated_date date,
user_id bigint
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table prodtype_master(
prodtype_id bigint identity(1,1) primary key,
prodtype_name varchar(100),
prodtype_desc varchar(max),
created_date date,
updated_date date,
user_id bigint
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table brand_mast(
brand_id bigint identity(1,1) primary key,
brand_name varchar(100) unique,
brand_desc varchar(max),
created_date date,
updated_date date,
user_id bigint
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------


create table paytype_mast(
paytype_id bigint identity(1,1) primary key,
paytype_name varchar(100) unique,
paytype_desc varchar(max),
created_date date,
updated_date date,
user_id bigint
foreign key(user_id) references user_Mast(user_id)
)

---------------------------------------------------------------

create table customer_mast(
customer_id bigint identity(1,1) primary key,
customer_name varchar(100) not null unique,
prefix varchar(6),
gender varchar(10),
phonenumber varchar(12),
city_id bigint,
cust_address varchar(max),
email_id varchar(max),
dob date,
aadhaar_number varchar(15),
license_number varchar(18),
pan_number varchar(12),
gst_number varchar(25),
is_active bit,
customer_notes varchar(50),
created_date date,
updated_date date,
user_id bigint
foreign key(city_id) references city_mast(city_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table vendor_mast(
vendor_id bigint identity(1,1) primary key,
vendor_name varchar(100) not null unique,
prefix varchar(6),
gender varchar(10),
phonenumber varchar(12),
city_id bigint,
[address] varchar(max),
email_id varchar(max),
dob date,
aadhaar_number varchar(15),
license_number varchar(18),
pan_number varchar(12),
gst_number varchar(25),
is_active bit,
vendor_notes varchar(50),
created_date date,
updated_date date,
user_id bigint
foreign key(city_id) references city_mast(city_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table product_mast(
product_id bigint identity(1,1) primary key,
prodtype_id bigint,
brand_id bigint,
hsn_id bigint,
unit_id bigint,
product_name varchar(100) not null unique,
product_desc varchar(max),
rate decimal(12,2),
opening_stock decimal(10,2),
purchase decimal(10,2),
sales decimal(10,2),
[return] decimal(10,2),
current_stock as ((opening_Stock + purchase)-(sales + [return])),
reorder_threshold decimal(10,2),
reorder_desc varchar(max),
created_date date,
updated_date date,
user_id bigint
foreign key(prodtype_id) references prodtype_master(prodtype_id),
foreign key(brand_id) references brand_mast(brand_id),
foreign key(hsn_id) references hsn_mast(hsn_id),
foreign key(unit_id) references unit_mast(unit_id),
foreign Key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table inward_mast(
inward_id bigint identity(1,1) primary key,
customer_id bigint,
product_id bigint,
totalquantity decimal(10,2),
balance decimal(10,2),
inward_status bit,
remarks varchar(50),
fin_year_id bigint,
comp_id bigint,
created_date date,
updated_date date,
user_id bigint
foreign key(customer_id) references customer_mast(customer_id),
foreign key(product_id) references product_mast(product_id),
foreign key(fin_year_id) references fin_year_mast(fin_year_id),
foreign key(comp_id) references company_mast(comp_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table inward_return(
inwardreturn_id bigint identity(1,1) primary key,
inward_id bigint,
customer_id bigint,
product_id bigint,
returnquantity decimal(10,2),
remarks varchar(50),
fin_year_id bigint,
comp_id bigint,
created_date date,
updated_date date,
user_id bigint
foreign key(inward_id) references inward_mast(inward_id),
foreign key(customer_id) references customer_mast(customer_id),
foreign key(product_id) references product_mast(product_id),
foreign key(fin_year_id) references fin_year_mast(fin_year_id),
foreign key(comp_id) references company_mast(comp_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table salesinvoice_mast(
sales_id bigint identity(1,1) primary key,
prefix varchar(6),
suffix varchar(6),
customer_id bigint,
sales_date date,
gross_total decimal(12,2),
sgst_total decimal(12,2),
cgst_total decimal(12,2),
igst_total decimal(12,2),
discount_total decimal(12,2),
roundoff_total decimal(12,2),
net_total decimal(12,2),
balance decimal(10,2),
payment_status bit,
isactive bit,
fin_year_id bigint,
comp_id bigint,
created_date date,
updated_date date,
user_id bigint
foreign key(customer_id) references customer_mast(customer_id),
foreign key(fin_Year_id) references fin_year_mast(fin_Year_id),
foreign key(comp_id) references company_mast(comp_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table salesinvoicedetails(
sales_detail_id bigint identity(1,1) primary key,
sales_id bigint,
inward_id bigint,
product_id bigint,
colour_id bigint,
unit_id bigint,
length decimal(12,2),
width decimal(12,2),
height decimal(12,2),
kg decimal(12,2),
liters decimal(12,2),
totalsqf_runningfeet decimal(12,2),
rate decimal(12,2),
totalquantity decimal(10,2),
gross_amt decimal(12,2),
sgst_perc decimal(5,2),
sgst_amt decimal(12,2),
cgst_perc decimal(5,2),
cgst_amt decimal(12,2),
igst_perc decimal(5,2),
igst_amt decimal(12,2),
discount_perc decimal(5,2),
discount_amt decimal(12,2),
total_amt decimal(12,2),
fin_year_id bigint,
comp_id bigint,
created_date date,
updated_date date,
user_id bigint
foreign key(sales_id) references salesinvoice_mast(sales_id),
foreign key(inward_id) references inward_mast(inward_id),
foreign key(product_id) references product_mast(product_id),
foreign key(colour_id) references colour_mast(colour_id),
foreign key(unit_id) references unit_mast(unit_id),
foreign key(fin_year_id) references fin_year_mast(fin_year_id),
foreign key(comp_id) references company_mast(comp_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table challan_mast(
challan_id bigint identity(1,1) primary key,
sales_id bigint,
fin_year_id bigint,
comp_id bigint,
created_date date,
updated_date date,
user_id bigint
foreign Key(sales_id) references salesinvoice_mast(sales_id),
foreign key(fin_year_id) references fin_year_mast(fin_year_id),
foreign key(comp_id) references company_mast(comp_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------


create table receipt_mast(
receipt_id bigint identity(1,1) primary key,
sales_id bigint,
recepit_date date,
net_total decimal(12,2),
balance_amount decimal(12,2),
receipt_status bit,
fin_year_id bigint,
comp_id bigint,
created_date date,
updated_date date,
user_id bigint
foreign key(sales_Id) references salesinvoice_mast(sales_id),
foreign key(fin_year_id) references fin_year_mast(fin_year_id),
foreign key(comp_id) references company_mast(comp_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------


create table receipt_details(
receipt_dtl_id  bigint identity(1,1) primary key,
receipt_id bigint,
paytype_id bigint,
total_amt decimal(12,2),
cheque_number varchar(10),
cheque_bankname varchar(100),
ifsc_code varchar(10),
cheque_date date,
account_number varchar(25),
transaction_id varchar(30),
card_number varchar(4),
transaction_date date,
fin_year_id bigint,
comp_id bigint,
created_date date,
updated_date date,
user_id bigint
foreign key(receipt_id) references receipt_mast(receipt_id),
foreign key(paytype_id) references paytype_Mast(paytype_id),
foreign key(fin_year_id) references fin_year_mast(fin_year_id),
foreign key(comp_id) references company_mast(comp_id),
foreign key(user_id) references user_Mast(user_id)
)

---------------------------------------------------------------


create table purchaseinvoice_mast(
purchase_id bigint identity(1,1) primary key,
prefix varchar(6),
suffix varchar(6),
invoive_no varchar(16),
purchase_date date,
vendor_id bigint,
gross_total decimal(12,2),
sgst_total decimal(12,2),
cgst_total decimal(12,2),
igst_total decimal(12,2),
discount_total decimal(12,2),
roundoff_total decimal(12,2),
net_total decimal(12,2),
balance decimal(12,2),
paymentstatus bit,
is_active bit,
fin_year_id bigint,
comp_id bigint,
created_date date,
updated_date date,
user_id bigint
foreign key(vendor_id) references vendor_mast(vendor_id),
foreign key(fin_year_id) references fin_year_mast(fin_year_id),
foreign key(comp_id) references company_mast(comp_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------


create table purchaseinvoice_details(
purchase_detail_id bigint identity(1,1) primary key,		
purchase_id bigint,
product_id bigint,
colour_id bigint,
unit_id bigint,
length decimal(12,2),
width decimal(12,2),
height decimal(12,2),
kg decimal(12,2),
liters decimal(12,2),
totalsqf_runningfeet decimal(12,2),
rate decimal(12,2),  					
gross_amt decimal(12,2),
totalquantity decimal(10,2),
sgst_perc decimal(5,2),
sgst_amt decimal(12,2),
cgst_perc decimal(5,2),
cgst_amt decimal(12,2),
igst_perc decimal(5,2),
igst_amt decimal(12,2),
discount_perc decimal(5,2),
discount_amt decimal(12,2),
total_amt decimal(12,2),
created_date date,
updated_date date,
fin_year_id bigint,
comp_id bigint,
user_id bigint
foreign key(purchase_id) references purchaseinvoice_mast(purchase_id),
foreign key(product_id) references product_mast(product_id),
foreign key(colour_id) references colour_mast(colour_id),
foreign key(unit_id) references unit_mast(unit_id),
foreign key(fin_year_id) references fin_year_mast(fin_year_id),
foreign key(comp_id) references company_mast(comp_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------


create table trans_type_mast(
trans_id bigint identity(1,1) primary key,
transtype_name	varchar(100),	
transtype_desc	varchar(max),	
created_date date,	
updated_date date,		
user_id	bigint,
foreign key (user_id) references user_mast(user_id)
)

----------------------------------------------------------------------------------------------------------

create table dailyconsumption_mast(
dailycons_id bigint identity(1,1) primary key,
dailycons_date date,
product_id	bigint,
unit_id	bigint,
quantityconsumed decimal(10,2),		
purpose	varchar(max),	
fin_year_id bigint,
comp_id bigint,
created_date date,
updated_date date,
user_id bigint
foreign key(product_id) references product_mast(product_id),
foreign key(unit_id) references unit_mast(unit_id),
foreign key(fin_year_id) references fin_year_mast(fin_year_id),
foreign key(comp_id) references company_mast(comp_id),
foreign key(user_id) references user_Mast(user_id)
)

---------------------------------------------------------------

create table employee_desg_mast(
desg_id bigint identity(1,1) primary key,
desg_name varchar(100),
desg_desc varchar(max),
daily_wk_hr decimal(5,2), 
created_date date,
updated_date date,
user_id bigint
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------


create table employee_mast(
employee_id bigint identity(1,1) primary key,
desg_id bigint,
first_name varchar(100), 
last_name varchar(100),
gender varchar(10),
dob date,  
phone_number varchar(12),  
emailid varchar(max),
[address] varchar(max), 
city_id bigint,
aadhaar_number varchar(15),
pan_number varchar(12),
bankaccount_no  varchar(20),
ifsc_code varchar(8),
joining_date  date,
relieving_date date,
education varchar(100),
exp_year decimal(5,2),
annual_salary decimal(12,2),
active_status bit, 
created_date date,
updated_date date,
fin_year_id bigint,
comp_id bigint,
user_id bigint
foreign key(desg_id) references employee_desg_mast(desg_id),
foreign key(city_id) references city_mast(city_id),
foreign key(fin_year_id) references fin_year_mast(fin_year_id),
foreign key(comp_id) references company_mast(comp_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------


create table leavetype_mast(
leavetype_id bigint identity(1,1) primary key,
yearsincompany decimal(5,2),
allocated_leaves decimal(5,2),
leave_name varchar(100),
leave_desc varchar(max),
casual_leaves decimal(5,2),
sick_leaves decimal(5,2),
created_date date,
updated_date date,
user_id bigint
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------


create table emp_leave_mast(
emp_leave_id bigint identity(1,1) primary key,
employee_id bigint,
fin_year_id bigint,
month_id bigint,
emp_leave_date date,
leavetype_id bigint,
total_allocated_leaves decimal(4,2),
leaves_used decimal(4,2),
leaves_balance decimal(4,2),
created_date date,
updated_date date,
user_id bigint
foreign key(employee_id) references employee_mast(employee_id),
foreign key(fin_year_id) references fin_year_mast(fin_year_id),
foreign key(month_id) references month_mast(month_id),
foreign key(leavetype_Id) references leavetype_mast(leavetype_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------


create table employee_payslip(
emp_payslip_id bigint identity(1,1) primary key,
fin_year_id bigint,
month_id bigint,
company_id bigint,
employee_id bigint,
emp_calender_id bigint,
employee_working_days decimal(4,2),
actual_working_days decimal(4,2),
actual_working_hours decimal(5,2),
monthly_salary decimal(12,2),
hourly_salary decimal(12,2),
over_time_hours decimal(5,2),
over_time_amount decimal(12,2),
gross_amount decimal(12,2),
pf_amount decimal(12,2),
tds_amount decimal(12,2),
advance_amount decimal(12,2),
netamount decimal(12,2),
remarks varchar(100),
created_date date,
updated_date date,
user_id bigint
foreign key(fin_year_id) references fin_year_mast(fin_year_id),
foreign key(month_id) references month_mast(month_id),
foreign key(company_id) references company_mast(comp_id),
foreign key(employee_id) references employee_mast(employee_id),
foreign key(emp_calender_id) references emp_calenderdays(emp_calender_id),
foreign key(user_id) references user_mast(user_id)
)

---------------------------------------------------------------


create table payment_mast(
payment_id bigint identity(1,1) primary key,
trans_id bigint,		
purchase_id bigint,	
emp_payslip_id bigint,
payment_date date,		
net_total decimal(12,2),			
balance_total  decimal(12,2),			
payment_status bit,		
created_date date,		
updated_date  date,			
fin_year_id bigint,	
comp_id bigint,				
user_id bigint	
foreign key (trans_id) references trans_type_mast(trans_id),
foreign key (purchase_id) references purchaseinvoice_mast(purchase_id),
foreign key (emp_payslip_id) references employee_payslip(emp_payslip_id),
foreign key (comp_id) references company_mast(comp_id),
foreign key (fin_year_id) references fin_year_mast(fin_year_id),
foreign key (user_id) references user_mast(user_id)
)

---------------------------------------------------------------

create table payment_details(
payment_detail_id bigint identity(1,1) primary key,	
payment_id bigint,				
pay_type_id	 bigint,			
total_amt decimal(12,2),		
cheque_number varchar(20),		
cheque_bankname varchar(100),	
ifsc_code varchar(11),			
cheque_date	date,	
account_number varchar(20),	
transaction_id varchar(50),		
card_number	varchar(4),		
transaction_date date,	
created_date date,		
updated_date date,		
fin_year_id  bigint,			
comp_id  bigint,				
user_id	 bigint		
foreign key (payment_id) references payment_mast(payment_id),
foreign key (pay_type_id) references trans_type_mast(trans_id),
foreign key (comp_id) references company_mast(comp_id),
foreign key (fin_year_id) references fin_year_mast(fin_year_id),
foreign key (user_id) references user_mast(user_id)
)

---------------------------------------------------------------


