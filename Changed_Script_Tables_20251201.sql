SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[user_details](
	[user_details_id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [bigint] NULL,
	[comp_id] [bigint] NULL,
	[fin_year_id] [bigint] NULL,
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

ALTER TABLE [dbo].[user_details]  WITH CHECK ADD FOREIGN KEY(fin_year_id)
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO


ALTER TABLE [dbo].[user_details]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

ALTER TABLE [dbo].[user_details]  WITH CHECK ADD FOREIGN KEY([modified_by])
REFERENCES [dbo].[user_mast] ([user_id])
GO
--------------------------------------------------------------------------------------------------------------------------------
--drop table receipt_mast;
--drop table receipt_details;
CREATE TABLE [dbo].[receipt_mast](
	[receipt_id] [bigint] IDENTITY(1,1) NOT NULL,
	[sales_id] [bigint] NULL,
	[customer_id] [bigint] NULL,
	[recepit_date] [date] NULL,
	[net_total] [decimal](12, 2) NULL,
	[Net_Paid_total] [decimal](12, 2) NULL,
	[balance_amount] [decimal](12, 2) NULL,
	[receipt_type] varchar(50) NULL,
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

ALTER TABLE [dbo].[receipt_mast]  WITH CHECK ADD FOREIGN KEY([customer_id])
REFERENCES [dbo].[customer_mast] ([customer_id])
GO

ALTER TABLE [dbo].[receipt_mast]  WITH CHECK ADD FOREIGN KEY([comp_id])
REFERENCES [dbo].[company_mast] ([comp_id])
GO

ALTER TABLE [dbo].[receipt_mast]  WITH CHECK ADD FOREIGN KEY([fin_year_id])
REFERENCES [dbo].[fin_year_mast] ([fin_year_id])
GO

ALTER TABLE [dbo].[receipt_mast]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO

Alter table receipt_mast
drop column receipt_type;

--------------------------------------------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[receipt_details](
	[receipt_dtl_id] [bigint] IDENTITY(1,1) NOT NULL,
	[receipt_id] [bigint] NULL,
	[paytype_id] [bigint] NULL,
	[trans_type_id] [bigint] NULL,
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

ALTER TABLE [dbo].[receipt_details]  WITH CHECK ADD FOREIGN KEY([trans_type_id])
REFERENCES [dbo].[trans_type_mast] ([trans_id])
GO


ALTER TABLE [dbo].[receipt_details]  WITH CHECK ADD FOREIGN KEY([receipt_id])
REFERENCES [dbo].[receipt_mast] ([receipt_id])
GO

ALTER TABLE [dbo].[receipt_details]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[user_mast] ([user_id])
GO


--------------------------------------------------------------------------------------------------------------------------------