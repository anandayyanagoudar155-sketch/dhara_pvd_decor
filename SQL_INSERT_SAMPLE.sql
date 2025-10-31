
select *from country_mast;
select *from state_mast;
select *from city_Mast;
select *from customer_mast;
select *from salesinvoicedetails
select *from product_mast
select*from user_mast
select*from user_details
select * from brand_mast

-----------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO country_mast(country_name, created_date, updated_date, user_id)
VALUES
('India', GETDATE(), NULL, NULL),
('United States', GETDATE(), NULL, NULL);

-----------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO state_mast(state_name, country_id, created_date, updated_date, user_id)
VALUES
('Maharashtra', 2, GETDATE(), NULL, NULL),
('California', 3, GETDATE(), NULL, NULL);

-----------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO city_Mast(city_name, state_id, created_date, updated_date, user_id)
VALUES
('Mumbai', 2, GETDATE(), NULL, NULL),
('Los Angeles', 3, GETDATE(), NULL, NULL);

-----------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO customer_mast 
(customer_name, prefix, gender, phonenumber, city_id, cust_address, email_id, dob, aadhaar_number, license_number, pan_number, gst_number, is_active, customer_notes, created_date, updated_date, user_id)
VALUES 
('John Doe', 'Mr.', 'M', '1234567890', 1, '123 Main St, Cityville', 'john.doe@example.com', '1985-04-12', '1234-5678-9012', 'DL123456', 'ABCDE1234F', 'GST1234567', 1, 'Preferred customer', GETDATE(), NULL, NULL),
('Jane Smith', 'Ms.', 'F', '0987654321', 2, '456 Elm St, Townsville', 'jane.smith@example.com', '1990-09-25', '2345-6789-0123', 'DL654321', 'XYZAB5678K', 'GST7654321', 1, 'Frequent buyer', GETDATE(), NULL, NULL);

-----------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO prodtype_master(prodtype_name, prodtype_desc, created_date, updated_date, user_id)
VALUES ('Electronics', 'Electronic gadgets and devices', '2025-10-28', '2025-10-28', null),
('Furniture', 'Home and office furniture', '2025-10-28', '2025-10-28', null),
('Clothing', 'Apparel and garments', '2025-10-28', '2025-10-28', null);

-----------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO brand_mast(brand_name, brand_desc, created_date, updated_date, user_id)
VALUES 
  ('Brand A', 'Description A', '2025-10-28', '2025-10-28', null),
  ('Brand B', 'Description B', '2025-10-28', '2025-10-28', null),
  ('Brand C', 'Description C', '2025-10-28', '2025-10-28', null);
 
-----------------------------------------------------------------------------------------------------------------------------------------

 INSERT INTO hsn_mast (hsn_code, cgst_perc, sgst_perc, igst_perc, created_date, updated_date, user_id)
VALUES
  ('HSN001', 9.00, 9.00, 18.00, '2025-10-28', '2025-10-28', null),
  ('HSN002', 2.50, 2.50, 5.00, '2025-10-28', '2025-10-28', null),
  ('HSN003', 6.00, 6.00, 12.00, '2025-10-28', '2025-10-28', null);

-----------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO unit_mast (unit_name, unit_desc, is_active, created_date, updated_date, user_id)
VALUES
  ('Kilogram', 'Weight measurement unit', 1, '2025-10-28', '2025-10-28', null),
  ('Liter', 'Volume measurement unit', 1, '2025-10-28', '2025-10-28', null),
  ('Piece', 'Single count unit', 1, '2025-10-28', '2025-10-28', null);
-----------------------------------------------------------------------------------------------------------------------------------------

  INSERT INTO product_mast 
    (prodtype_id, brand_id, hsn_id, unit_id, product_name, product_desc, rate,
     opening_stock, Purchase, Sales, [Return], Reorder_Threshold, Reorder_Desc, created_date, updated_date, user_id)
VALUES
  (1, 1, 1, 1, 'Product A', 'Description A', 100.00, 50, 20, 10, 2, 15, 'Reorder soon', '2025-10-28', '2025-10-28', null),
  (2, 2, 2, 2, 'Product B', 'Description B', 200.00, 100, 40, 20, 5, 30, 'Reorder soon', '2025-10-28', '2025-10-28', null),
  (3, 3, 3, 3, 'Product C', 'Description C', 150.00, 80, 50, 15, 1, 20, 'Reorder soon', '2025-10-28', '2025-10-28', null);

-----------------------------------------------------------------------------------------------------------------------------------------
  INSERT INTO inward_mast
    (customer_id, product_id, totalquantity, inward_status, remarks, fin_year_id, comp_id, created_date, updated_date, user_id)
VALUES
    (7, 1, 100.00, 1, 'First inward entry', null, null, '2025-10-28', '2025-10-28', null),
    (7, 2, 200.00, 1, 'Second inward entry', null, null, '2025-10-28', '2025-10-28', null),
    (6, 3, 150.00, 0, 'Third inward entry', null, null, '2025-10-28', '2025-10-28', null);

-----------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO inward_return
    (inward_id, customer_id, product_id, returnquantity, remarks, fin_year_id, comp_id, created_date, updated_date, user_id)
VALUES
    (4, 7, 1, 5.00, 'Return 1', null, null, '2025-10-28', '2025-10-28', null),
    (5, 7, 2, 3.00, 'Return 2', null, null, '2025-10-28', '2025-10-28', null),
    (6, 6, 3, 2.00, 'Return 3', null, null, '2025-10-28', '2025-10-28', null);

-----------------------------------------------------------------------------------------------------------------------------------------

exec customer_mast_insert_update_del 'delete',5


  select * from prodtype_master
  select * from brand_mast
  select * from hsn_mast
  select * from unit_mast
  select * from product_mast

  select * from customer_mast;
  select * from inward_mast;
  select * from inward_return;
  select * from company_mast


  select * from employee_payslip


  delete from inward_mast
  delete from inward_return

