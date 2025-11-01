
EXEC sp_user_mast_ins_upd_del 'insert',0,'admin', 'Admin@123', 'Administrator', 0, NULL, NULL;
EXEC sp_user_mast_ins_upd_del 'insert',0,'john_doe', 'John@2025', 'Manager', 0, NULL, NULL;
EXEC sp_user_mast_ins_upd_del 'insert',0,'mary_smith', 'Mary#Pass', 'Staff', 0, NULL, NULL;
EXEC sp_user_mast_ins_upd_del 'insert',0,'rohit_kumar', 'Rohit@2024', 'Support', 0, NULL, NULL;
EXEC sp_user_mast_ins_upd_del 'insert',0,'guest_user', 'Guest#123', 'Viewer', 0, NULL, NULL;

select * from user_mast;
----------------------------------------------------------------------------------------------------------

INSERT INTO country_mast(country_name, created_date, updated_date, user_id)
VALUES
('India', GETDATE(), NULL, NULL),
('United States', GETDATE(), NULL, NULL);

select * from country_mast;
-----------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO state_mast(state_name, country_id, created_date, updated_date, user_id)
VALUES
('Maharashtra', 1, GETDATE(), NULL, NULL),
('California', 2, GETDATE(), NULL, NULL);

select * from state_mast;
-----------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO city_Mast(city_name, state_id, created_date, updated_date, user_id)
VALUES
('Mumbai', 3, GETDATE(), NULL, NULL),
('Los Angeles', 4, GETDATE(), NULL, NULL);

select * from city_Mast;
-----------------------------------------------------------------------------------------------------------

EXEC sp_company_mast_ins_upd_del 'insert',0,'COMP001', 'Dhara PVD Decor Pvt Ltd', 'DPVD', 'Private Limited', 
'Manufacturer of decorative coatings', 'CIN12345XYZ', 'GSTIN1234ABC', 'PAN1234XYZ', 'Anand Ayyanagoudar', 
'anand@dhara.com', '9876543210', 'Plot No.12, Industrial Area', 'Phase 2', 2, '560001', 1, NULL, NULL, 
'/images/logo1.png', 1;

EXEC sp_company_mast_ins_upd_del 'insert',0,'COMP002', 'Sai Enterprises', 'SAI', 'Proprietorship', 
'Trading and logistics firm', 'CIN67890PQR', 'GSTIN5678DEF', 'PAN5678DEF', 'Rohit Kumar', 
'rohit@sai.com', '9988776655', 'Main Road', 'Opposite City Mall', 2, '110002', 1,NULL, NULL, 
'/images/logo2.png', 1;

EXEC sp_company_mast_ins_upd_del 'insert',0,'COMP003', 'Bright Tech Solutions', 'BTS', 'Partnership', 
'IT and software solutions provider', 'CIN11223LMN', 'GSTIN1122LMN', 'PAN1122LMN', 'Mary Smith', 
'mary@brighttech.com', '9123456780', 'Tech Park', 'Tower B, Level 3', 3, '400001', 1,NULL, NULL, 
'/images/logo3.png', 1;

EXEC sp_company_mast_ins_upd_del 'insert',0,'COMP004', 'Green Agro Farms', 'GAF', 'LLP', 
'Agricultural and organic product exporter', 'CIN99887OPQ', 'GSTIN9988OPQ', 'PAN9988OPQ', 'John Doe', 
'john@greenagro.com', '9012345678', 'Farm Road', 'Sector 7', 3, '380015', 1, NULL, NULL, 
'/images/logo4.png', 1;

EXEC sp_company_mast_ins_upd_del 'insert',0,'COMP005', 'UrbanBuild Constructions', 'UBC', 'Private Limited', 
'Residential and commercial builders', 'CIN77665RST', 'GSTIN7766RST', 'PAN7766RST', 'Priya Verma', 
'priya@urbanbuild.com', '9876501234', 'Plot 21, Skyline Road', 'Near Metro Station', 3, '600089', 1, NULL, NULL, 
'/images/logo5.png', 1;

select * from company_mast;
----------------------------------------------------------------------------------------------------------

EXEC sp_user_details_ins_upd_del 'insert', 0, 1, 6, 1, NULL, NULL, 1;
EXEC sp_user_details_ins_upd_del 'insert', 0, 2, 7, 1, NULL, NULL, 1;
EXEC sp_user_details_ins_upd_del 'insert', 0, 3, 8, 1, NULL, NULL, 1;
EXEC sp_user_details_ins_upd_del 'insert', 0, 4, 9, 1, NULL, NULL, 1;
EXEC sp_user_details_ins_upd_del 'insert', 0, 5, 10, 0, NULL, NULL, 1;

select * from user_details;

----------------------------------------------------------------------------------------------------------

EXEC sp_colour_mast_ins_upd_del 'insert', 0, 'Golden Oak', 1, NULL, NULL, 1;
EXEC sp_colour_mast_ins_upd_del 'insert', 0, 'Rosewood', 1, NULL, NULL, 1;
EXEC sp_colour_mast_ins_upd_del 'insert', 0, 'Walnut Brown', 1, NULL, NULL, 2;
EXEC sp_colour_mast_ins_upd_del 'insert', 0, 'Matte Black', 1, NULL, NULL, 2;
EXEC sp_colour_mast_ins_upd_del 'insert', 0, 'Antique White', 0, NULL, NULL, 1;

select * from colour_mast;

-----------------------------------------------------------------------------------------------------------

EXEC sp_unit_mast_ins_upd_del 'insert', 0, 'Piece', 'Used for individual countable items', 1, NULL, NULL, 1;
EXEC sp_unit_mast_ins_upd_del 'insert', 0, 'Kilogram', 'Measurement for weight-based items', 1, NULL, NULL, 1;
EXEC sp_unit_mast_ins_upd_del 'insert', 0, 'Meter', 'Measurement for length-based materials', 1, NULL, NULL, 2;
EXEC sp_unit_mast_ins_upd_del 'insert', 0, 'Box', 'Used for packed or grouped items', 1, NULL, NULL, 2;
EXEC sp_unit_mast_ins_upd_del 'insert', 0, 'Liter', 'Measurement for liquid items', 0, NULL, NULL, 1;

select * from unit_mast;

-----------------------------------------------------------------------------------------------------------


EXEC sp_hsn_mast_ins_upd_del 'insert', 0, '7326', 9.00, 9.00, 18.00, NULL, NULL, 1;
EXEC sp_hsn_mast_ins_upd_del 'insert', 0, '8481', 6.00, 6.00, 12.00, NULL, NULL, 1;
EXEC sp_hsn_mast_ins_upd_del 'insert', 0, '9403', 9.00, 9.00, 18.00, NULL, NULL, 2;
EXEC sp_hsn_mast_ins_upd_del 'insert', 0, '3926', 2.50, 2.50, 5.00, NULL, NULL, 2;
EXEC sp_hsn_mast_ins_upd_del 'insert', 0, '7308', 14.00, 14.00, 28.00, NULL, NULL, 1;

select * from hsn_mast;


-----------------------------------------------------------------------------------------------------------

EXEC sp_prodtype_mast_ins_upd_del 'insert', 0, 'Hardware', 'Includes metal parts, screws, and fittings', NULL, NULL, 1;
EXEC sp_prodtype_mast_ins_upd_del 'insert', 0, 'Coating', 'Products related to PVD and surface finishing', NULL, NULL, 1;
EXEC sp_prodtype_mast_ins_upd_del 'insert', 0, 'Glass', 'Glass sheets, mirrors, and customized glass panels', NULL, NULL, 2;
EXEC sp_prodtype_mast_ins_upd_del 'insert', 0, 'Furniture', 'Ready and custom-made furniture items', NULL, NULL, 2;
EXEC sp_prodtype_mast_ins_upd_del 'insert', 0, 'Accessories', 'Decorative and utility accessories for interiors', NULL, NULL, 1;

select * from prodtype_master;

-----------------------------------------------------------------------------------------------------------

EXEC sp_brand_mast_ins_upd_del 'insert', 0, 'Dulux', 'Leading paint and coating brand known for premium finishes', NULL, NULL, 1;
EXEC sp_brand_mast_ins_upd_del 'insert', 0, 'Asian Paints', 'Top Indian brand offering decorative and industrial coatings', NULL, NULL, 1;
EXEC sp_brand_mast_ins_upd_del 'insert', 0, 'Nerolac', 'Trusted coating and paint brand with eco-friendly products', NULL, NULL, 2;
EXEC sp_brand_mast_ins_upd_del 'insert', 0, '3M', 'Global brand known for surface solutions and adhesives', NULL, NULL, 2;
EXEC sp_brand_mast_ins_upd_del 'insert', 0, 'Saint-Gobain', 'Leading brand in glass, mirrors, and construction materials', NULL, NULL, 1;

select * from brand_mast;

-----------------------------------------------------------------------------------------------------------

EXEC sp_paytype_mast_ins_upd_del 'insert', 0, 'Cash', 'Payment made directly in cash', NULL, NULL, 1;
EXEC sp_paytype_mast_ins_upd_del 'insert', 0, 'Credit Card', 'Payment through credit card transaction', NULL, NULL, 1;
EXEC sp_paytype_mast_ins_upd_del 'insert', 0, 'UPI', 'Unified Payments Interface digital payment', NULL, NULL, 2;
EXEC sp_paytype_mast_ins_upd_del 'insert', 0, 'Bank Transfer', 'Direct transfer to company bank account', NULL, NULL, 2;
EXEC sp_paytype_mast_ins_upd_del 'insert', 0, 'Cheque', 'Offline cheque-based payment', NULL, NULL, 1;

select * from paytype_mast;

-----------------------------------------------------------------------------------------------------------

EXEC sp_customer_mast_ins_upd_del 'insert', 0, 'Rohit Sharma', 'Mr.', 'Male', '9876543210', 2, 
'101 MG Road, Pune', 'rohit.sharma@email.com', '1990-04-12', '123456789012', 'MH12DL123456789', 
'ABCDE1234F', 'GSTIN1234XYZ', 1, 'Regular Customer', NULL, NULL, 1;

EXEC sp_customer_mast_ins_upd_del 'insert', 0, 'Priya Verma', 'Ms.', 'Female', '9123456780', 2, 
'45 Residency Road, Bengaluru', 'priya.verma@email.com', '1995-09-20', '234567890123', 'KA09DL234567890', 
'FGHIJ5678K', 'GSTIN5678LMN', 1, 'Prefers online orders', NULL, NULL, 1;

EXEC sp_customer_mast_ins_upd_del 'insert', 0, 'Amit Patel', 'Mr.', 'Male', '9988776655', 3, 
'22 Ring Road, Ahmedabad', 'amit.patel@email.com', '1988-02-10', '345678901234', 'GJ01DL345678901', 
'KLMNO9012P', 'GSTIN9012PQR', 1, 'Frequent buyer', NULL, NULL, 2;

EXEC sp_customer_mast_ins_upd_del 'insert', 0, 'Sneha Rao', 'Mrs.', 'Female', '9000012345', 3, 
'5th Cross, Indiranagar, Bengaluru', 'sneha.rao@email.com', '1992-07-05', '456789012345', 'KA03DL456789012', 
'PQRST3456L', 'GSTIN3456DEF', 0, 'Inactive since 2023', NULL, NULL, 2;

EXEC sp_customer_mast_ins_upd_del 'insert', 0, 'Arjun Mehta', 'Mr.', 'Male', '9823456701', 3, 
'Plot 9, Andheri East, Mumbai', 'arjun.mehta@email.com', '1993-11-22', '567890123456', 'MH02DL567890123', 
'UVWXY6789M', 'GSTIN6789ABC', 1, 'Bulk orders monthly', NULL, NULL, 1;


select * from customer_mast;

-----------------------------------------------------------------------------------------------------------

EXEC sp_product_mast_ins_upd_del 'insert', 0, 6, 6, 1, 1, 'Stainless Steel Handle', 'High quality steel door handle', 150.00, 50.00, 20.00, 10.00, 2.00, 0.00, 10.00,'Reorder when stock falls below 10',NULL, NULL, 1;

EXEC sp_product_mast_ins_upd_del 'insert', 0, 7, 7, 2, 2, 'Aluminium Curtain Rod', 'Durable aluminium rod for curtains', 320.00, 40.00, 10.00, 8.00, 1.00, 0.00, 8.00, 'Reorder threshold 8 pcs', NULL, NULL, 1;

EXEC sp_product_mast_ins_upd_del 'insert', 0, 8, 8, 3, 3, 'Glass Door Knob', 'Round crystal door knob for interiors', 450.00, 30.00, 15.00, 10.00, 2.00, 0.00, 5.00, 'Maintain 5 pcs minimum', NULL, NULL, 2;

EXEC sp_product_mast_ins_upd_del 'insert', 0, 9, 9, 4, 4, 'Wooden Hanger Set', 'Polished wooden hangers for clothing racks', 200.00, 60.00, 25.00, 15.00, 3.00, 0.00, 15.00, 'Reorder if below 15 pcs', NULL, NULL, 2;

EXEC sp_product_mast_ins_upd_del 'insert', 0, 10, 10, 5, 5, 'PVC Pipe Connector', 'PVC fitting for plumbing applications', 95.00, 100.00, 40.00, 30.00, 5.00,  0.00, 20.00, 'Minimum 20 pcs required', NULL, NULL, 1;


select * from product_mast;
select * from prodtype_master;
select * from brand_mast;
select * from hsn_mast;
select * from unit_mast;

-----------------------------------------------------------------------------------------------------------

EXEC sp_inward_mast_ins_upd_del 'insert', 0, 1, 22, 150.00, 1, 'Received full quantity', NULL, 6, NULL, NULL, 1;

EXEC sp_inward_mast_ins_upd_del 'insert', 0, 2, 23, 75.00, 1, 'Partial inward completed', NULL, 7, NULL, NULL, 2;

EXEC sp_inward_mast_ins_upd_del 'insert', 0, 3, 24, 200.00, 0, 'Pending inspection', NULL, 8, NULL, NULL, 1;

EXEC sp_inward_mast_ins_upd_del 'insert', 0, 4, 25, 95.00, 1, 'Verified and stored', NULL, 9, NULL, NULL, 2;

EXEC sp_inward_mast_ins_upd_del 'insert', 0, 5, 26, 120.00, 0, 'Awaiting approval', NULL, 10, NULL, NULL, 1;


select * from inward_mast;
select * from customer_mast;
select * from product_mast;
select* from company_mast;



----------------------------------

EXEC sp_inward_return_ins_upd_del 'insert', 0, 6, 1, 22, 5.00, 'Damaged during delivery', NULL, NULL, NULL, NULL, 1;

EXEC sp_inward_return_ins_upd_del 'insert', 0, 7, 2, 23, 2.50, 'Wrong product received', NULL, NULL, NULL, NULL, 2;

EXEC sp_inward_return_ins_upd_del 'insert', 0, 8, 3, 24, 10.00, 'Quality issue reported', NULL, NULL, NULL, NULL, 1;

EXEC sp_inward_return_ins_upd_del 'insert', 0, 9, 4, 25, 3.00, 'Excess stock returned', NULL, NULL, NULL, NULL, 2;

EXEC sp_inward_return_ins_upd_del 'insert', 0, 10, 5, 26, 1.00, 'Customer cancelled order', NULL, NULL, NULL, NULL, 1;


select * from inward_return;
select * from inward_mast;
---------------------------------------------------------------------

EXEC sp_salesinvoice_mast_ins_upd_del 'insert', 0, 'INV', '001', 1, null, 25000.00, 2250.00, 2250.00, 0.00, 500.00, 0.50, 29000.50, 1, 1, null, null, null, NULL, 1;

EXEC sp_salesinvoice_mast_ins_upd_del 'insert', 0, 'INV', '002', 2, null, 18000.00, 1620.00, 1620.00, 0.00, 300.00, -0.25, 20500.75, 1, 1, null, null, null, NULL, 2;

EXEC sp_salesinvoice_mast_ins_upd_del 'insert', 0, 'INV', '003', 3, null, 32000.00, 2880.00, 2880.00, 0.00, 800.00, 0.25, 37560.25, 0, 1, null, null, null, NULL, 1;

EXEC sp_salesinvoice_mast_ins_upd_del 'insert', 0, 'INV', '004', 1, null, 14500.00, 1305.00, 1305.00, 0.00, 200.00, 0.75, 16110.75, 1, 1, null, null, null, NULL, 2;

EXEC sp_salesinvoice_mast_ins_upd_del 'insert', 0, 'INV', '005', 4, null, 22000.00, 1980.00, 1980.00, 0.00, 400.00, -0.50, 25459.50, 0, 1, null, null, null, NULL, 1;


select * from salesinvoice_mast;
select * from customer_mast;

-----------------------------------------------------------------------


EXEC sp_salesinvoicedetails_ins_upd_del 'insert', 0, 6, 6, 22, 1, 1, 12.00, 8.00, 0.00, 25.00, 0.00, 96.00, 250.00, 10.00, 2500.00, 9.00, 225.00, 9.00, 225.00, 0.00, 0.00, 5.00, 125.00, 2825.00, NULL, NULL, NULL, NULL, 1;

EXEC sp_salesinvoicedetails_ins_upd_del 'insert', 0, 7, 7, 23, 2, 1, 10.00, 5.00, 0.00, 15.00, 0.00, 50.00, 300.00, 8.00, 2400.00, 9.00, 216.00, 9.00, 216.00, 0.00, 0.00, 2.50, 60.00, 2772.00, NULL, NULL, NULL, NULL, 2;

EXEC sp_salesinvoicedetails_ins_upd_del 'insert', 0, 8, 8, 24, 3, 2, 15.00, 10.00, 0.00, 30.00, 0.00, 150.00, 200.00, 12.00, 2400.00, 9.00, 216.00, 9.00, 216.00, 0.00, 0.00, 4.00, 96.00, 2832.00, NULL, NULL, NULL, NULL, 1;

EXEC sp_salesinvoicedetails_ins_upd_del 'insert', 0, 9, 9, 25, 4, 2, 20.00, 8.00, 0.00, 35.00, 0.00, 160.00, 350.00, 6.00, 2100.00, 9.00, 189.00, 9.00, 189.00, 0.00, 0.00, 3.00, 63.00, 2515.00, NULL, NULL, NULL, NULL, 2;

EXEC sp_salesinvoicedetails_ins_upd_del 'insert', 0, 10, 10, 26, 5, 3, 25.00, 12.00, 0.00, 50.00, 0.00, 300.00, 275.00, 5.00, 1375.00, 9.00, 123.75, 9.00, 123.75, 0.00, 0.00, 2.00, 27.50, 1650.00, NULL, NULL, NULL, NULL, 1;


select * from salesinvoicedetails;
select * from salesinvoice_mast;
select * from inward_mast;
select * from product_mast;
select * from colour_mast;
select * from unit_mast;

-----------------------------------------------------------------------


EXEC sp_challan_mast_ins_upd_del 'insert',0, 6, NULL, NULL, NULL, NULL, 1;
EXEC sp_challan_mast_ins_upd_del 'insert',0, 7, NULL, NULL, NULL, NULL, 2;
EXEC sp_challan_mast_ins_upd_del 'insert',0, 8, NULL, NULL, NULL, NULL, 1;
EXEC sp_challan_mast_ins_upd_del 'insert',0, 9, NULL, NULL, NULL, NULL, 2;
EXEC sp_challan_mast_ins_upd_del 'insert',0, 10, NULL, NULL, NULL, NULL, 1;

select * from challan_mast
select * from salesinvoice_mast


-----------------------------------------------------------------------


EXEC sp_receipt_mast_ins_upd_del 'insert', 0, 6, NULL, 29000.50, 0.00, 1, NULL, NULL, NULL, NULL, 1;

EXEC sp_receipt_mast_ins_upd_del 'insert', 0, 7, NULL, 20500.75, 500.00, 1, NULL, NULL, NULL, NULL, 2;

EXEC sp_receipt_mast_ins_upd_del 'insert', 0, 8, NULL, 37560.25, 1500.00, 0, NULL, NULL, NULL, NULL, 1;

EXEC sp_receipt_mast_ins_upd_del 'insert', 0, 9, NULL, 16110.75, 0.00, 1, NULL, NULL, NULL, NULL, 2;

EXEC sp_receipt_mast_ins_upd_del 'insert', 0, 10, NULL, 25459.50, 25459.50, 0, NULL, NULL, NULL, NULL, 1;


select * from receipt_mast;
select * from salesinvoice_mast
-----------------------------------------------------------------------


-- 1. Payment via Cheque
EXEC sp_receipt_details_ins_upd_del 'insert', 0, 1, 10, 15000.00, '458976', 'HDFC Bank', 'HDFC0001', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1;

-- 2. Payment via Online Transfer (Transaction ID)
EXEC sp_receipt_details_ins_upd_del 'insert', 0, 2, 8, 20500.75, NULL, NULL, NULL, NULL, '9876543210123456', 'TXN2025110101', NULL, NULL, NULL, NULL, NULL, NULL, 2;

-- 3. Payment via Credit Card
EXEC sp_receipt_details_ins_upd_del 'insert', 0, 3, 7, 12560.25, NULL, NULL, NULL, NULL, NULL, 'TXN2025110102', '6589', NULL, NULL, NULL, NULL, NULL, 1;

-- 4. Payment via Cheque (Different Bank)
EXEC sp_receipt_details_ins_upd_del 'insert', 0, 4, 10, 9500.00, '789654', 'ICICI Bank', 'ICIC0005', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2;

-- 5. Payment via UPI Transaction
EXEC sp_receipt_details_ins_upd_del 'insert', 0, 5, 8, 17500.00, NULL, NULL, NULL, NULL, NULL, 'UPI2025110103', NULL, NULL, NULL, NULL, NULL, NULL, 1;


select * from receipt_details;
select * from receipt_mast;
select * from paytype_mast;

-----------------------------------------------------------------------

select * from errorlog;



