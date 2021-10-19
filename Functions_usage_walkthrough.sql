-- Конвертирование типов данных

SELECT *
FROM [sales].[stores]

SELECT zip_code,
       CAST(zip_code AS INT) AS zip_int,
       CONVERT(DECIMAL(10, 2), zip_code) AS zip_decimal,
       CONVERT(MONEY, zip_code) AS zip_decimal
FROM [sales].[stores]

SELECT 'The zip code is ' + zip_code
FROM [sales].[stores]

SELECT GETDATE() AS UnconvertedDateTime,
       CAST(GETDATE() AS NVARCHAR(30)) AS UsingCast,
       CONVERT(NVARCHAR(30), GETDATE(), 126) AS UsingConvertTo_ISO8601

-- Даты

SELECT DISTINCT TOP 10
       order_date,
       DATEDIFF(dd, order_date, GETDATE()) AS days_ago,
       DATEADD(m, 5, order_date) AS five_months_after,
       YEAR(order_date) AS order_year,
       DATEPART(dw, order_date) AS order_weekday,
       DATENAME(dw, order_date) AS month_name
FROM [sales].[orders]

-- Математические
SELECT DISTINCT TOP 10
       list_price,
       ROUND(list_price, 0) AS round_price,
       FLOOR(list_price) AS floor_price,
       PI() AS pi_value,
       POWER(list_price, 2) AS list_price_square
FROM [sales].[order_items]

-- Текстовые
UPDATE [production].[categories]
SET [category_name] = '     NoName category     '
WHERE category_id = 8

SELECT 1
WHERE 'Test' = 'Test'

SELECT [category_id],
       [category_name],
       UPPER([category_name]) AS upper_category,
       LTRIM([category_name]),
       REPLACE(category_name, 'Bikes', 'Bicycles'),
       SUBSTRING(category_name, 1, 5),
       CHARINDEX(' ', category_name),
       SUBSTRING(category_name, 1, CHARINDEX(' ', category_name) - 1)
FROM [production].[categories]

-- LIKE
SELECT product_name
FROM [production].[products]
WHERE product_name LIKE 'trek%'
--product_name LIKE '%[CS]heryl%'
--product_name LIKE '%[^C]heryl%'
--product_name LIKE '%_heryl%'
--product_name LIKE '%[%]%'

--CASE

SELECT c.customer_id,
       c.last_name,
       c.first_name,
       SUM(oi.list_price - oi.list_price * oi.discount) AS total_sales,
       CASE
           WHEN SUM(oi.list_price - oi.list_price * oi.discount)
                BETWEEN 10000 AND 20000 THEN
               'Try more'
           WHEN SUM(oi.list_price - oi.list_price * oi.discount) > 20000 THEN
               'My favorite client'
           ELSE
               'I dont like you'
       END AS Client_category,
       CASE
           WHEN c.last_name LIKE '[A-K]%' THEN
               'A-K'
           WHEN c.last_name LIKE '[L-T]%' THEN
               'L-T'
           WHEN c.last_name LIKE '[O-Z]%' THEN
               'O-Z'
       END AS Lastname_group,
       c.[state],
       CASE c.[state]
           WHEN 'CA' THEN
               'California'
           WHEN 'NY' THEN
               'New York'
           WHEN 'TX' THEN
               'Texas'
           ELSE
               'Unknown'
       END AS Customer_state
FROM [sales].[customers] c
    INNER JOIN [sales].[orders] o
        ON c.customer_id = o.customer_id
    INNER JOIN [sales].[order_items] oi
        ON oi.order_id = o.order_id
GROUP BY c.customer_id,
         c.last_name,
         c.first_name,
         c.[state]
ORDER BY total_sales DESC

--CASE TODO: Для всех продуктов, у которых последние 4 символа в названии продукта равны 2018 и название бренда равно 'Surly' посчитайте сумму продаж. 
--На основе суммы продаж категоризируйте продукты. Если сумма продаж = 0, то категория равна 'No sales'. Если сумма продаж строго меньше 2000, то категория равна 'Bad'. Если сумма продаж от 2000 до 5000 включительно с обеиз сторон, то категория равна 'Good'. Если сумма продаж строго больше 5000, то категория равна 'Excellent'.
--Функции TODO: Посчитайте сумму продаж велосипедов для каждого месяца (учитывая года). месяц и год берем из даты заказа. Продажи берем из деталей заказа, как разницу между list price и discount * list price.

SELECT  product_id,
        product_name
        SUM(list_price - list_price * discount) AS total_sales
        product_category
FROM [production].[products]