---1
CREATE TABLE [dbo].[user_mast](
	[user_id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_name] [varchar](100) NOT NULL,
	[user_password] [varchar](100) NOT NULL,
	[user_role] [varchar](50) NULL,
	[is_login] [bit] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[user_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[user_password] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



---2
CREATE TABLE [dbo].[country_mast](
	[country_id] [bigint] IDENTITY(1,1) NOT NULL,
	[country_name] [varchar](100) NOT NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[country_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[country_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



ALTER TABLE [dbo].[country_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO


---3
/****** Object:  Table [dbo].[state_mast]    Script Date: 21-11-2025 18:53:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[state_mast](
	[state_id] [bigint] IDENTITY(1,1) NOT NULL,
	[state_name] [varchar](100) NOT NULL,
	[country_id] [bigint] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[state_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[state_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[state_mast]  WITH CHECK ADD FOREIGN KEY([country_id])
REFERENCES [dbo].[country_mast] ([country_id])
GO

ALTER TABLE [dbo].[state_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO


----4

/****** Object:  Table [dbo].[city_mast]    Script Date: 21-11-2025 18:53:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[city_mast](
	[city_id] [bigint] IDENTITY(1,1) NOT NULL,
	[city_name] [varchar](100) NOT NULL,
	[state_id] [bigint] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[city_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[city_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[city_mast]  WITH CHECK ADD FOREIGN KEY([state_id])
REFERENCES [dbo].[state_mast] ([state_id])
GO

ALTER TABLE [dbo].[city_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO


---5
CREATE TABLE [dbo].[month_mast](
	[month_id] [bigint] IDENTITY(1,1) NOT NULL,
	[month_name] [varchar](50) NOT NULL,
	[start_date] [date] NULL,
	[end_date] [date] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[month_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[month_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---6
CREATE TABLE [dbo].[fin_year_mast](
	[fin_year_id] [bigint] IDENTITY(1,1) NOT NULL,
	[fin_name] [varchar](50) NOT NULL,
	[short_fin_year] [varchar](10) NULL,
	[year_start] [date] NULL,
	[year_end] [date] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[fin_year_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[fin_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[fin_year_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

ALTER TABLE fin_year_mast
ADD CONSTRAINT CHK_FinYear_ValidDates
CHECK (
        DATEPART(DAY, year_start) = 1 
    AND DATEPART(MONTH, year_start) = 4 
    AND DATEPART(DAY, year_end) = 31
    AND DATEPART(MONTH, year_end) = 3
);


---7
CREATE TABLE [dbo].[employee_desg_mast](
	[desg_id] [bigint] IDENTITY(1,1) NOT NULL,
	[desg_name] [varchar](100) NULL,
	[desg_desc] [varchar](max) NULL,
	[daily_wk_hr] [decimal](5, 2) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[desg_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[employee_desg_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---8
CREATE TABLE [dbo].[leavetype_mast](
	[leavetype_id] [bigint] IDENTITY(1,1) NOT NULL,
	[yearsincompany] [decimal](5, 2) NULL,
	[allocated_leaves] [decimal](5, 2) NULL,
	[leave_name] [varchar](100) NULL,
	[leave_desc] [varchar](max) NULL,
	[casual_leaves] [decimal](5, 2) NULL,
	[sick_leaves] [decimal](5, 2) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[leavetype_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[leavetype_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---9
CREATE TABLE [dbo].[errorlog](
	[errorlogid] [int] IDENTITY(1,1) NOT NULL,
	[errornumber] [int] NULL,
	[errorprocedure] [nvarchar](128) NULL,
	[errorline] [int] NULL,
	[errormessage] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[errorlogid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


---10
CREATE TABLE [dbo].[colour_mast](
	[colour_id] [bigint] IDENTITY(1,1) NOT NULL,
	[colour_name] [varchar](50) NOT NULL,
	[is_active] [bit] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[colour_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[colour_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[colour_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---11
CREATE TABLE [dbo].[unit_mast](
	[unit_id] [bigint] IDENTITY(1,1) NOT NULL,
	[unit_name] [varchar](50) NOT NULL,
	[unit_desc] [varchar](max) NULL,
	[is_active] [bit] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[unit_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[unit_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[unit_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO
---12
CREATE TABLE [dbo].[hsn_mast](
	[hsn_id] [bigint] IDENTITY(1,1) NOT NULL,
	[hsn_code] [varchar](10) NULL,
	[cgst_perc] [decimal](5, 2) NULL,
	[sgst_perc] [decimal](5, 2) NULL,
	[igst_perc] [decimal](5, 2) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[hsn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[hsn_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[hsn_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO
---13

CREATE TABLE [dbo].[prodtype_master](
	[prodtype_id] [bigint] IDENTITY(1,1) NOT NULL,
	[prodtype_name] [varchar](100) NULL,
	[prodtype_desc] [varchar](max) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[prodtype_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[prodtype_master]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO
---14
CREATE TABLE [dbo].[brand_mast](
	[brand_id] [bigint] IDENTITY(1,1) NOT NULL,
	[brand_name] [varchar](100) NULL,
	[brand_desc] [varchar](max) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[brand_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[brand_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[brand_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---15
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[paytype_mast](
	[paytype_id] [bigint] IDENTITY(1,1) NOT NULL,
	[paytype_name] [varchar](100) NULL,
	[paytype_desc] [varchar](max) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[paytype_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[paytype_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[paytype_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---16
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[trans_type_mast](
	[trans_id] [bigint] IDENTITY(1,1) NOT NULL,
	[transtype_name] [varchar](100) NULL,
	[transtype_desc] [varchar](max) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[trans_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[trans_type_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO
---17
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[company_mast](
	[comp_id] [bigint] IDENTITY(1,1) NOT NULL,
	[comp_code] [varchar](25) NOT NULL,
	[comp_name] [varchar](100) NOT NULL,
	[comp_short_name] [varchar](6) NOT NULL,
	[comp_type] [varchar](50) NULL,
	[comp_desc] [varchar](max) NULL,
	[cin_number] [varchar](25) NULL,
	[gst_number] [varchar](25) NULL,
	[pan_number] [varchar](12) NULL,
	[contperson_name] [varchar](100) NULL,
	[contact_email] [varchar](max) NULL,
	[contact_phone] [varchar](12) NULL,
	[address_line1] [varchar](max) NULL,
	[address_line2] [varchar](max) NULL,
	[city_id] [bigint] NULL,
	[pincode] [varchar](6) NULL,
	[is_active] [bit] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[logo_path] [varchar](max) NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[comp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[comp_short_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[comp_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[comp_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[company_mast]  WITH CHECK ADD FOREIGN KEY([city_id])
REFERENCES [dbo].[city_mast] ([city_id])
GO

ALTER TABLE [dbo].[company_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---Done-Changed added comp_id
---18
CREATE TABLE [dbo].[emp_calenderdays](
	[emp_calender_id] [bigint] IDENTITY(1,1) NOT NULL,
	[comp_id] [bigint] NULL,
	[fin_year_id] [bigint] NULL,
	[month_id] [bigint] NULL,
	[month_days] [decimal](5, 2) NULL,
	[emp_holidays] [decimal](5, 2) NULL,
	[emp_weekend] [decimal](5, 2) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[emp_calender_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[emp_calenderdays]  WITH CHECK ADD FOREIGN KEY([month_id])
REFERENCES [dbo].[month_mast] ([month_id])
GO

ALTER TABLE [dbo].[emp_calenderdays]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[emp_calenderdays]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

ALTER TABLE [dbo].[emp_calenderdays]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO


---19
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[user_details](
	[user_details_id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[is_active] [bit] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[modified_by] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[user_details_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[user_details]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[user_details]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

ALTER TABLE [dbo].[user_details]  WITH CHECK ADD FOREIGN KEY([modified_by])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---20
---Changed
CREATE TABLE [dbo].[product_mast](
	[product_id] [bigint] IDENTITY(1,1) NOT NULL,
	[prodtype_id] [bigint] NULL,
	[brand_id] [bigint] NULL,
	[hsn_id] [bigint] NULL,
	[unit_id] [bigint] NULL,
	[product_name] [varchar](100) NOT NULL,
	[product_desc] [varchar](max) NULL,
	[rate] [decimal](12, 2) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[product_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[product_mast]  WITH CHECK ADD FOREIGN KEY([brand_id])
REFERENCES [dbo].[brand_mast] ([brand_id])
GO

ALTER TABLE [dbo].[product_mast]  WITH CHECK ADD FOREIGN KEY([hsn_id])
REFERENCES [dbo].[hsn_mast] ([hsn_id])
GO

ALTER TABLE [dbo].[product_mast]  WITH CHECK ADD FOREIGN KEY([unit_id])
REFERENCES [dbo].[unit_mast] ([unit_id])
GO

ALTER TABLE [dbo].[product_mast]  WITH CHECK ADD FOREIGN KEY([prodtype_id])
REFERENCES [dbo].[prodtype_master] ([prodtype_id])
GO

ALTER TABLE [dbo].[product_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---21
---Changed
CREATE TABLE [dbo].[product_details](
	[product_details_id] [bigint] IDENTITY(1,1) NOT NULL,
	[product_id] [bigint] NOT NULL,
	[opening_stock] [decimal](10, 2) NULL,
	[purchase] [decimal](10, 2) NULL,
	[sales] [decimal](10, 2) NULL,
	[return] [decimal](10, 2) NULL,
	[current_stock]  AS (([opening_Stock]+[purchase])-([sales]+[return])),
	[reorder_threshold] [decimal](10, 2) NULL,
	[reorder_desc] [varchar](max) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[product_details_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[product_details]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[product_mast] ([product_id])
GO

ALTER TABLE [dbo].[product_details]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[product_details]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[product_details]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---22
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[customer_mast](
	[customer_id] [bigint] IDENTITY(1,1) NOT NULL,
	[customer_name] [varchar](100) NOT NULL,
	[prefix] [varchar](6) NULL,
	[gender] [varchar](10) NULL,
	[phonenumber] [varchar](12) NULL,
	[city_id] [bigint] NULL,
	[cust_address] [varchar](max) NULL,
	[email_id] [varchar](max) NULL,
	[dob] [date] NULL,
	[aadhaar_number] [varchar](15) NULL,
	[license_number] [varchar](18) NULL,
	[pan_number] [varchar](12) NULL,
	[gst_number] [varchar](25) NULL,
	[is_active] [bit] NULL,
	[customer_notes] [varchar](50) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[customer_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[customer_mast]  WITH CHECK ADD FOREIGN KEY([city_id])
REFERENCES [dbo].[city_mast] ([city_id])
GO

ALTER TABLE [dbo].[customer_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---23
---Changed
CREATE TABLE [dbo].[customer_details](
	[customer_details_id] [bigint] IDENTITY(1,1) NOT NULL,
	[customer_id] [bigint] NOT NULL,
	opening_balance decimal(12,2),
	Invoice_balance decimal(12,2),
	Outstanding_balance decimal(12,2),
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_details_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[customer_details]  WITH CHECK ADD FOREIGN KEY([customer_id])
REFERENCES [dbo].[customer_mast] ([customer_id])
GO

ALTER TABLE [dbo].[customer_details]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[customer_details]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[customer_details]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---24
CREATE TABLE [dbo].[vendor_mast](
	[vendor_id] [bigint] IDENTITY(1,1) NOT NULL,
	[vendor_name] [varchar](100) NOT NULL,
	[prefix] [varchar](6) NULL,
	[gender] [varchar](10) NULL,
	[phonenumber] [varchar](12) NULL,
	[city_id] [bigint] NULL,
	[address] [varchar](max) NULL,
	[email_id] [varchar](max) NULL,
	[dob] [date] NULL,
	[aadhaar_number] [varchar](15) NULL,
	[license_number] [varchar](18) NULL,
	[pan_number] [varchar](12) NULL,
	[gst_number] [varchar](25) NULL,
	[is_active] [bit] NULL,
	[vendor_notes] [varchar](50) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[vendor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[vendor_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[vendor_mast]  WITH CHECK ADD FOREIGN KEY([city_id])
REFERENCES [dbo].[city_mast] ([city_id])
GO

ALTER TABLE [dbo].[vendor_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---25
---Done Changed
CREATE TABLE [dbo].[vendor_details](
	[vendor_details_id] [bigint] IDENTITY(1,1) NOT NULL,
	[vendor_id] [bigint] NOT NULL,
	opening_balance decimal(12,2),
	Invoice_balance decimal(12,2),
	Outstanding_balance decimal(12,2),
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[vendor_details_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[vendor_details]  WITH CHECK ADD FOREIGN KEY([vendor_id])
REFERENCES [dbo].[vendor_mast] ([vendor_id])
GO

ALTER TABLE [dbo].[vendor_details]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[vendor_details]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[vendor_details]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---26
CREATE TABLE [dbo].[employee_mast](
	[employee_id] [bigint] IDENTITY(1,1) NOT NULL,
	[desg_id] [bigint] NULL,
	[first_name] [varchar](100) NULL,
	[last_name] [varchar](100) NULL,
	[gender] [varchar](10) NULL,
	[dob] [date] NULL,
	[phone_number] [varchar](12) NULL,
	[emailid] [varchar](max) NULL,
	[address] [varchar](max) NULL,
	[city_id] [bigint] NULL,
	[aadhaar_number] [varchar](15) NULL,
	[pan_number] [varchar](12) NULL,
	[bankaccount_no] [varchar](20) NULL,
	[ifsc_code] [varchar](8) NULL,
	[joining_date] [date] NULL,
	[relieving_date] [date] NULL,
	[education] [varchar](100) NULL,
	[exp_year] [decimal](5, 2) NULL,
	[annual_salary] [decimal](12, 2) NULL,
	[active_status] [bit] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[employee_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[employee_mast]  WITH CHECK ADD FOREIGN KEY([city_id])
REFERENCES [dbo].[city_mast] ([city_id])
GO

ALTER TABLE [dbo].[employee_mast]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[employee_mast]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[employee_mast]  WITH CHECK ADD FOREIGN KEY([desg_id])
REFERENCES [dbo].[employee_desg_mast] ([desg_id])
GO

ALTER TABLE [dbo].[employee_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---27
CREATE TABLE [dbo].[inward_mast](
	[inward_id] [bigint] IDENTITY(1,1) NOT NULL,
	[customer_id] [bigint] NULL,
	[product_id] [bigint] NULL,
	[totalquantity] [decimal](10, 2) NULL,
	[balance_quantity] [decimal](10, 2) NULL,
	[inward_status] [bit] NULL,
	[remarks] [varchar](50) NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[inward_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[inward_mast]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[inward_mast]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[inward_mast]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[product_mast] ([product_id])
GO

ALTER TABLE [dbo].[inward_mast]  WITH CHECK ADD FOREIGN KEY([customer_id])
REFERENCES [dbo].[customer_mast] ([customer_id])
GO

ALTER TABLE [dbo].[inward_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO



---28
CREATE TABLE [dbo].[inward_return](
	[inwardreturn_id] [bigint] IDENTITY(1,1) NOT NULL,
	[inward_id] [bigint] NULL,
	[customer_id] [bigint] NULL,
	[product_id] [bigint] NULL,
	[returnquantity] [decimal](10, 2) NULL,
	[remarks] [varchar](50) NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[inwardreturn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[inward_return]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[inward_return]  WITH CHECK ADD FOREIGN KEY([customer_id])
REFERENCES [dbo].[customer_mast] ([customer_id])
GO

ALTER TABLE [dbo].[inward_return]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[inward_return]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[product_mast] ([product_id])
GO

ALTER TABLE [dbo].[inward_return]  WITH CHECK ADD FOREIGN KEY([inward_id])
REFERENCES [dbo].[inward_mast] ([inward_id])
GO

ALTER TABLE [dbo].[inward_return]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO



---29
CREATE TABLE [dbo].[salesinvoice_mast](
	[sales_id] [bigint] IDENTITY(1,1) NOT NULL,
	[prefix] [varchar](6) NULL,
	[suffix] [varchar](6) NULL,
	[customer_id] [bigint] NULL,
	[sales_date] [date] NULL,
	[gross_total] [decimal](12, 2) NULL,
	[sgst_total] [decimal](12, 2) NULL,
	[cgst_total] [decimal](12, 2) NULL,
	[igst_total] [decimal](12, 2) NULL,
	[discount_total] [decimal](12, 2) NULL,
	[roundoff_total] [decimal](12, 2) NULL,
	[net_total] [decimal](12, 2) NULL,
	[balance_total] [decimal](12, 2) NULL,
	[payment_status] [bit] NULL,
	[isactive] [bit] NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[sales_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[salesinvoice_mast]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[salesinvoice_mast]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[salesinvoice_mast]  WITH CHECK ADD FOREIGN KEY([customer_id])
REFERENCES [dbo].[customer_mast] ([customer_id])
GO

ALTER TABLE [dbo].[salesinvoice_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO




---30
CREATE TABLE [dbo].[salesinvoicedetails](
	[sales_detail_id] [bigint] IDENTITY(1,1) NOT NULL,
	[sales_id] [bigint] NULL,
	[inward_id] [bigint] NULL,
	[product_id] [bigint] NULL,
	[colour_id] [bigint] NULL,
	[unit_id] [bigint] NULL,
	[length] [decimal](12, 2) NULL,
	[width] [decimal](12, 2) NULL,
	[height] [decimal](12, 2) NULL,
	[kg] [decimal](12, 2) NULL,
	[liters] [decimal](12, 2) NULL,
	[totalsqf_runningfeet] [decimal](12, 2) NULL,
	[rate] [decimal](12, 2) NULL,
	[totalquantity] [decimal](10, 2) NULL,
	[gross_amt] [decimal](12, 2) NULL,
	[sgst_perc] [decimal](5, 2) NULL,
	[sgst_amt] [decimal](12, 2) NULL,
	[cgst_perc] [decimal](5, 2) NULL,
	[cgst_amt] [decimal](12, 2) NULL,
	[igst_perc] [decimal](5, 2) NULL,
	[igst_amt] [decimal](12, 2) NULL,
	[discount_perc] [decimal](5, 2) NULL,
	[discount_amt] [decimal](12, 2) NULL,
	[total_amt] [decimal](12, 2) NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[sales_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[salesinvoicedetails]  WITH CHECK ADD FOREIGN KEY([colour_id])
REFERENCES [dbo].[colour_mast] ([colour_id])
GO

ALTER TABLE [dbo].[salesinvoicedetails]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[salesinvoicedetails]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[salesinvoicedetails]  WITH CHECK ADD FOREIGN KEY([inward_id])
REFERENCES [dbo].[inward_mast] ([inward_id])
GO

ALTER TABLE [dbo].[salesinvoicedetails]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[product_mast] ([product_id])
GO

ALTER TABLE [dbo].[salesinvoicedetails]  WITH CHECK ADD FOREIGN KEY([unit_id])
REFERENCES [dbo].[unit_mast] ([unit_id])
GO

ALTER TABLE [dbo].[salesinvoicedetails]  WITH CHECK ADD FOREIGN KEY([sales_id])
REFERENCES [dbo].[salesinvoice_mast] ([sales_id])
GO

ALTER TABLE [dbo].[salesinvoicedetails]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO




---31
CREATE TABLE [dbo].[challan_mast](
	[challan_id] [bigint] IDENTITY(1,1) NOT NULL,
	[sales_id] [bigint] NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[challan_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[challan_mast]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[challan_mast]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[challan_mast]  WITH CHECK ADD FOREIGN KEY([sales_id])
REFERENCES [dbo].[salesinvoice_mast] ([sales_id])
GO

ALTER TABLE [dbo].[challan_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO



---32
CREATE TABLE [dbo].[receipt_mast](
	[receipt_id] [bigint] IDENTITY(1,1) NOT NULL,
	[sales_id] [bigint] NULL,
	[recepit_date] [date] NULL,
	[net_total] [decimal](12, 2) NULL,
	[balance_amount] [decimal](12, 2) NULL,
	[receipt_status] [bit] NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[receipt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[receipt_mast]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[receipt_mast]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[receipt_mast]  WITH CHECK ADD FOREIGN KEY([sales_id])
REFERENCES [dbo].[salesinvoice_mast] ([sales_id])
GO

ALTER TABLE [dbo].[receipt_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO



---33
CREATE TABLE [dbo].[receipt_details](
	[receipt_dtl_id] [bigint] IDENTITY(1,1) NOT NULL,
	[receipt_id] [bigint] NULL,
	[paytype_id] [bigint] NULL,
	[total_amt] [decimal](12, 2) NULL,
	[cheque_number] [varchar](10) NULL,
	[cheque_bankname] [varchar](100) NULL,
	[ifsc_code] [varchar](10) NULL,
	[cheque_date] [date] NULL,
	[account_number] [varchar](25) NULL,
	[transaction_id] [varchar](30) NULL,
	[card_number] [varchar](4) NULL,
	[transaction_date] [date] NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[receipt_dtl_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[receipt_details]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[receipt_details]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[receipt_details]  WITH CHECK ADD FOREIGN KEY([paytype_id])
REFERENCES [dbo].[paytype_mast] ([paytype_id])
GO

ALTER TABLE [dbo].[receipt_details]  WITH CHECK ADD FOREIGN KEY([receipt_id])
REFERENCES [dbo].[receipt_mast] ([receipt_id])
GO

ALTER TABLE [dbo].[receipt_details]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO



---34
CREATE TABLE [dbo].[purchaseinvoice_mast](
	[purchase_id] [bigint] IDENTITY(1,1) NOT NULL,
	[prefix] [varchar](6) NULL,
	[suffix] [varchar](6) NULL,
	[invoive_no] [varchar](16) NULL,
	[purchase_date] [date] NULL,
	[vendor_id] [bigint] NULL,
	[gross_total] [decimal](12, 2) NULL,
	[sgst_total] [decimal](12, 2) NULL,
	[cgst_total] [decimal](12, 2) NULL,
	[igst_total] [decimal](12, 2) NULL,
	[discount_total] [decimal](12, 2) NULL,
	[roundoff_total] [decimal](12, 2) NULL,
	[net_total] [decimal](12, 2) NULL,
	[balance_total] [decimal](12, 2) NULL,
	[paymentstatus] [bit] NULL,
	[is_active] [bit] NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[purchase_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[purchaseinvoice_mast]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[purchaseinvoice_mast]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[purchaseinvoice_mast]  WITH CHECK ADD FOREIGN KEY([vendor_id])
REFERENCES [dbo].[vendor_mast] ([vendor_id])
GO

ALTER TABLE [dbo].[purchaseinvoice_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO



---35
CREATE TABLE [dbo].[purchaseinvoice_details](
	[purchase_detail_id] [bigint] IDENTITY(1,1) NOT NULL,
	[purchase_id] [bigint] NULL,
	[product_id] [bigint] NULL,
	[colour_id] [bigint] NULL,
	[unit_id] [bigint] NULL,
	[length] [decimal](12, 2) NULL,
	[width] [decimal](12, 2) NULL,
	[height] [decimal](12, 2) NULL,
	[kg] [decimal](12, 2) NULL,
	[liters] [decimal](12, 2) NULL,
	[totalsqf_runningfeet] [decimal](12, 2) NULL,
	[rate] [decimal](12, 2) NULL,
	[gross_amt] [decimal](12, 2) NULL,
	[totalquantity] [decimal](10, 2) NULL,
	[sgst_perc] [decimal](5, 2) NULL,
	[sgst_amt] [decimal](12, 2) NULL,
	[cgst_perc] [decimal](5, 2) NULL,
	[cgst_amt] [decimal](12, 2) NULL,
	[igst_perc] [decimal](5, 2) NULL,
	[igst_amt] [decimal](12, 2) NULL,
	[discount_perc] [decimal](5, 2) NULL,
	[discount_amt] [decimal](12, 2) NULL,
	[total_amt] [decimal](12, 2) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[purchase_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[purchaseinvoice_details]  WITH CHECK ADD FOREIGN KEY([colour_id])
REFERENCES [dbo].[colour_mast] ([colour_id])
GO

ALTER TABLE [dbo].[purchaseinvoice_details]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[purchaseinvoice_details]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[purchaseinvoice_details]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[product_mast] ([product_id])
GO

ALTER TABLE [dbo].[purchaseinvoice_details]  WITH CHECK ADD FOREIGN KEY([unit_id])
REFERENCES [dbo].[unit_mast] ([unit_id])
GO

ALTER TABLE [dbo].[purchaseinvoice_details]  WITH CHECK ADD FOREIGN KEY([purchase_id])
REFERENCES [dbo].[purchaseinvoice_mast] ([purchase_id])
GO

ALTER TABLE [dbo].[purchaseinvoice_details]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO



---36
CREATE TABLE [dbo].[dailyconsumption_mast](
	[dailycons_id] [bigint] IDENTITY(1,1) NOT NULL,
	[dailycons_date] [date] NULL,
	[product_id] [bigint] NULL,
	[unit_id] [bigint] NULL,
	[quantityconsumed] [decimal](10, 2) NULL,
	[purpose] [varchar](max) NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[dailycons_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[dailyconsumption_mast]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[dailyconsumption_mast]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[dailyconsumption_mast]  WITH CHECK ADD FOREIGN KEY([unit_id])
REFERENCES [dbo].[unit_mast] ([unit_id])
GO

ALTER TABLE [dbo].[dailyconsumption_mast]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[product_mast] ([product_id])
GO

ALTER TABLE [dbo].[dailyconsumption_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO



---37
---Changed-- Added comp_id
CREATE TABLE [dbo].[emp_leave_mast](
	[emp_leave_id] [bigint] IDENTITY(1,1) NOT NULL,
	[employee_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[fin_year_id] [bigint] NULL,	
	[month_id] [bigint] NULL,
	[emp_leave_date] [date] NULL,
	[leavetype_id] [bigint] NULL,
	[total_allocated_leaves] [decimal](4, 2) NULL,
	[leaves_used] [decimal](4, 2) NULL,
	[leaves_balance] [decimal](4, 2) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[emp_leave_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[emp_leave_mast]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[emp_leave_mast]  WITH CHECK ADD FOREIGN KEY([leavetype_id])
REFERENCES [dbo].[leavetype_mast] ([leavetype_id])
GO

ALTER TABLE [dbo].[emp_leave_mast]  WITH CHECK ADD FOREIGN KEY([month_id])
REFERENCES [dbo].[month_mast] ([month_id])
GO

ALTER TABLE [dbo].[emp_leave_mast]  WITH CHECK ADD FOREIGN KEY([employee_id])
REFERENCES [dbo].[employee_mast] ([employee_id])
GO

ALTER TABLE [dbo].[emp_leave_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

ALTER TABLE [dbo].[dailyconsumption_mast]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO


---38
CREATE TABLE [dbo].[employee_payslip](
	[emp_payslip_id] [bigint] IDENTITY(1,1) NOT NULL,
	[fin_year_id] [bigint] NULL,
	[month_id] [bigint] NULL,
	[company_id] [bigint] NULL,
	[employee_id] [bigint] NULL,
	[emp_calender_id] [bigint] NULL,
	[employee_working_days] [decimal](4, 2) NULL,
	[actual_working_days] [decimal](4, 2) NULL,
	[actual_working_hours] [decimal](5, 2) NULL,
	[monthly_salary] [decimal](12, 2) NULL,
	[hourly_salary] [decimal](12, 2) NULL,
	[over_time_hours] [decimal](5, 2) NULL,
	[over_time_amount] [decimal](12, 2) NULL,
	[gross_amount] [decimal](12, 2) NULL,
	[pf_amount] [decimal](12, 2) NULL,
	[tds_amount] [decimal](12, 2) NULL,
	[advance_amount] [decimal](12, 2) NULL,
	[netamount] [decimal](12, 2) NULL,
	[remarks] [varchar](100) NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[emp_payslip_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[employee_payslip]  WITH CHECK ADD FOREIGN KEY([company_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[employee_payslip]  WITH CHECK ADD FOREIGN KEY([emp_calender_id])
REFERENCES [dbo].[emp_calenderdays] ([emp_calender_id])
GO

ALTER TABLE [dbo].[employee_payslip]  WITH CHECK ADD FOREIGN KEY([employee_id])
REFERENCES [dbo].[employee_mast] ([employee_id])
GO

ALTER TABLE [dbo].[employee_payslip]  WITH CHECK ADD FOREIGN KEY([month_id])
REFERENCES [dbo].[month_mast] ([month_id])
GO

ALTER TABLE [dbo].[employee_payslip]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[employee_payslip]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO



---39
CREATE TABLE [dbo].[payment_mast](
	[payment_id] [bigint] IDENTITY(1,1) NOT NULL,
	[trans_id] [bigint] NULL,
	[purchase_id] [bigint] NULL,
	[emp_payslip_id] [bigint] NULL,
	[payment_date] [date] NULL,
	[net_total] [decimal](12, 2) NULL,
	[balance_total] [decimal](12, 2) NULL,
	[payment_status] [bit] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[payment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[payment_mast]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[payment_mast]  WITH NOCHECK ADD FOREIGN KEY([emp_payslip_id])
REFERENCES [dbo].[employee_payslip] ([emp_payslip_id])
GO

ALTER TABLE [dbo].[payment_mast]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[payment_mast]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[payment_mast]  WITH NOCHECK ADD FOREIGN KEY([purchase_id])
REFERENCES [dbo].[purchaseinvoice_mast] ([purchase_id])
GO

ALTER TABLE [dbo].[payment_mast]  WITH CHECK ADD FOREIGN KEY([trans_id])
REFERENCES [dbo].[trans_type_mast] ([trans_id])
GO

ALTER TABLE [dbo].[payment_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

---40
---Changed
CREATE TABLE [dbo].[payment_details](
	[payment_detail_id] [bigint] IDENTITY(1,1) NOT NULL,
	[payment_id] [bigint] NULL,
	[pay_type_id] [bigint] NULL,
	[trans_type_id] [bigint] NULL,
	[total_amount] [decimal](12, 2) NULL,
	[cheque_number] [varchar](20) NULL,
	[cheque_bankname] [varchar](50) NULL,
	[ifsc_code] [varchar](11) NULL,
	[cheque_date] [date] NULL,
	[account_number] [varchar](20) NULL,
	[transaction_id] [varchar](50) NULL,
	[card_number] [varchar](4) NULL,
	[transaction_date] [date] NULL,
	[created_date] [date] NULL,
	[updated_date] [date] NULL,
	[fin_year_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[user_id] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[payment_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[payment_details]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[payment_details]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[payment_details]  WITH CHECK ADD FOREIGN KEY([pay_type_id])
REFERENCES [dbo].[paytype_mast] ([paytype_id])
GO

ALTER TABLE [dbo].[payment_details]  WITH CHECK ADD FOREIGN KEY([trans_type_id])
REFERENCES [dbo].[trans_type_mast] ([trans_id])
GO

ALTER TABLE [dbo].[payment_details]  WITH CHECK ADD FOREIGN KEY([payment_id])
REFERENCES [dbo].[payment_mast] ([payment_id])
GO

ALTER TABLE [dbo].[payment_details]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO










