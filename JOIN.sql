-- INNER JOIN
-- Clarification
SELECT o.order_id,
       o.order_date,
       oi.product_id,
       oi.quantity,
       oi.list_price,
       oi.discount
FROM [sales].[orders] o
    INNER JOIN [sales].[order_items] oi
        ON o.order_id = oi.order_id
ORDER BY o.order_date,
         oi.product_id

SELECT o.order_id,
       o.order_date,
       p.product_name,
       oi.quantity,
       oi.list_price,
       oi.discount
FROM [sales].[orders] o
    INNER JOIN [sales].[order_items] oi
        ON o.order_id = oi.order_id
    INNER JOIN [production].[products] p
        ON p.product_id = oi.product_id
ORDER BY o.order_date,
         p.product_name

SELECT o.order_id,
       o.order_date,
       p.product_name,
       p.model_year,
       oi.quantity,
       oi.list_price,
       oi.discount
FROM [sales].[orders] o
    INNER JOIN [sales].[order_items] oi
        ON o.order_id = oi.order_id
    INNER JOIN [production].[products] p
        ON p.product_id = oi.product_id
           AND p.model_year = 2018
ORDER BY o.order_date,
         p.product_name

--Filter
SELECT p.product_id,
       p.product_name
FROM [production].[products] p

SELECT DISTINCT
       p.product_id,
       p.product_name
FROM [production].[products] p
    INNER JOIN [sales].[order_items] oi
        ON p.product_id = oi.product_id

SELECT p.product_id,
       p.product_name
FROM [production].[products] p
where p.product_id IN (select product_id from [sales].[order_items] oi)    

--LEFT JOIN
select p.product_id,
       p.product_name
from [production].[products] p
WHERE p.product_id IN (16, 125)

select p.product_id,
       p.product_name
from [production].[products] p
INNER JOIN [sales].[order_items] oi
        ON p.product_id = oi.product_id
WHERE p.product_id IN (16, 125)

select p.product_id,
       p.product_name,
       oi.order_id
from [production].[products] p
LEFT JOIN [sales].[order_items] oi
        ON p.product_id = oi.product_id
WHERE p.product_id IN (16, 125)

--125	Trek Kids' Dual Sport - 2018	NULL

SELECT p.product_id,
       p.product_name
FROM [production].[products] p
where p.product_id NOT IN (select product_id from [sales].[order_items] oi)   

SELECT p.product_id,
       p.product_name,
       oi.discount
FROM [sales].[order_items] oi
    RIGHT JOIN [production].[products] p
        ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL

-- FULL OUTER JOIN

select * from [production].[products] p where category_id IS NULL
select * from [production].[categories]

SELECT p.product_id,
       p.product_name,
       c.category_id,
       c.category_name
FROM [production].[products] p
    LEFT JOIN [production].[categories] c
        ON c.category_id = p.category_id
WHERE c.category_id IS NULL

SELECT p.product_id,
       p.product_name,
       c.category_id,
       c.category_name
FROM [production].[categories] c
    LEFT JOIN [production].[products] p
        ON c.category_id = p.category_id
WHERE p.category_id IS NULL

SELECT p.product_id,
       p.product_name,
       c.category_id,
       c.category_name
FROM [production].[categories] c
    FULL OUTER JOIN [production].[products] p
        ON c.category_id = p.category_id
ORDER BY p.product_id, c.category_id

SELECT p.product_id,
       p.product_name,
       c.category_id,
       c.category_name
FROM [production].[categories] c
    FULL OUTER JOIN [production].[products] p
        ON c.category_id = p.category_id
WHERE c.category_id IS NULL OR p.product_id IS NULL
ORDER BY p.product_id, c.category_id

-- CROSS JOIN

select * from [production].[brands]
select * from [production].[categories]

select * 
from [production].[brands] b
cross join [production].[categories] c
order by b.brand_id, c.category_id

--TODO For every product from model year 2016 calculate average discount, 
-- if there were no orders with this product show 0 as average discount, 
-- filter only products with average discount more or equal 0 and less or equal 0.105581

select [production].[products].product_id, ISNULL(AVG(discount), 0)  from production.products LEFT JOIN sales.order_items 
on [products].product_id = [order_items].product_id
HAVING (model_year = 2016 and (AVG(discount) > 0 and AVG(discount) <= 0.105581))