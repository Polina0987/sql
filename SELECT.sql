--SELECT
SELECT *
FROM [production].[products]

SELECT TOP (1000)
       [product_id],
       [product_name],
       [brand_id],
       [model_year],
       [list_price]
FROM [production].[products]

--SELECT with ORDER
SELECT [product_id],
       [product_name],
       [brand_id],
       [category_id],
       [model_year],
       [list_price]
FROM [production].[products]
ORDER BY [product_name],
         list_price DESC

--SELECT DISTINCT

SELECT DISTINCT
       [product_name], [model_year]
FROM [production].[products]

select 10/4.0

--SELECT with calculated columns: https://docs.microsoft.com/en-us/sql/t-sql/functions/functions?view=sql-server-ver15
SELECT [product_id],
       [product_name],
       [brand_id],
       [category_id],
       [model_year],
       [list_price],
       [list_price] * 10 / 100
FROM [production].[products]

SELECT [product_id],
       [product_name],
       [brand_id],
       [category_id],
       [model_year],
       [list_price],
       SIN(POWER([list_price], 2))
FROM [production].[products]

--SELECT with named columns
SELECT [product_id],
       [product_name],
       [brand_id],
       [category_id],
       [model_year],
       [list_price] AS price,
       [list_price] * 10 / 100 AS discount
FROM [production].[products]

--SELECT with WHERE
SELECT [product_id],
       [product_name],
       [brand_id],
       [category_id],
       [model_year],
       [list_price]
FROM [production].[products]
WHERE [list_price] >= 7000

SELECT [product_id],
       [product_name],
       [brand_id],
       [category_id],
       [model_year],
       [list_price]
FROM [production].[products]
WHERE [list_price] >= 500
      AND [model_year] IN ( 2015, 2016 )
      OR product_name LIKE 'Electra%'

--UNION ALL
SELECT brand_name
FROM [production].[brands]
UNION ALL
SELECT [category_name]
FROM [production].[categories]


--Data types: https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver15 
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[production].[products]') AND type in (N'U'))
DROP TABLE [production].[products]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [production].[products](
	[product_id] [int] IDENTITY(1,1) NOT NULL,
	[product_name] [varchar](255) NOT NULL,
	[brand_id] [int] NOT NULL,
	[category_id] [int] NULL,
	[model_year] [smallint] NOT NULL,
	[list_price] [decimal](10, 2) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [production].[products] ADD PRIMARY KEY CLUSTERED 
(
	[product_id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [production].[products]  WITH CHECK ADD FOREIGN KEY([brand_id])
REFERENCES [production].[brands] ([brand_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [production].[products]  WITH CHECK ADD FOREIGN KEY([category_id])
REFERENCES [production].[categories] ([category_id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

--TODO:
--Find all products which 
-- 1. Name starts from 'Sun' or include 'Girl' (even inside some specific word)
-- 2. Price is less than 1000
-- 3. From categories #3 or #6
SELECT [product_id],
       [product_name],
       [brand_id],
       [category_id],
       [model_year],
       [list_price]
FROM [production].[products]
WHERE (list_price < 1000 and (product_name like '%Girl%' or product_name like 'Sun%') AND (category_id = 3 OR category_id = 6))