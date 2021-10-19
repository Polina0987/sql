-- --SUBQUERY in join
-- SELECT TOP 10
--        *
-- FROM sales.order_items

-- SELECT p.product_id,
--        p.product_name,
--        MAX(oi.discount) AS max_discount
-- FROM [production].[products] p
--     INNER JOIN sales.order_items oi
--         ON oi.product_id = p.product_id
-- GROUP BY p.product_id,
--          p.product_name


-- SELECT p.product_id,
--        p.product_name,
--        oi.*
-- FROM [production].[products] p
--     INNER JOIN
--     (
--         SELECT product_id,
--                MAX(discount) AS max_discount
--         FROM sales.order_items
--         GROUP BY product_id
--     ) md
--         ON p.product_id = md.product_id
--     INNER JOIN sales.order_items oi
--         ON oi.product_id = p.product_id
--            AND oi.discount = md.max_discount
-- ORDER BY p.product_id

-- --SUBQUERY in select

-- SELECT p.product_id,
--        p.product_name,
--        (
--            SELECT MAX(order_date)
--            FROM [sales].[orders] o
--                INNER JOIN [sales].[order_items] oi
--                    ON o.order_id = oi.order_id
--            WHERE oi.product_id = p.product_id
--        ) AS last_order_date
-- FROM [production].[products] p
-- ORDER BY p.product_name

-- --SUBQUERY in where

-- SELECT p.product_id,
--        p.product_name,
--        o.order_date
-- FROM [production].[products] p
--     INNER JOIN sales.order_items oi
--         ON oi.product_id = p.product_id
--     INNER JOIN [sales].[orders] o
--         ON o.order_id = oi.order_id
-- WHERE o.order_date IN 
-- (
--     SELECT MAX(o_nested.order_date)
--     FROM [sales].[orders] o_nested
--         INNER JOIN [sales].[order_items] oi_nested
--             ON o_nested.order_id = oi_nested.order_id
--     WHERE oi_nested.product_id = p.product_id
-- )
-- ORDER BY p.product_name

--CTE - Common Table Expression
-- WITH max_discounts
-- AS (SELECT product_id,
--            MAX(discount) AS max_discount
--     FROM sales.order_items
--     GROUP BY product_id)
-- SELECT p.product_id,
--        p.product_name,
--        oi.*
-- FROM [production].[products] p
--     INNER JOIN max_discounts md
--         ON p.product_id = md.product_id
--     INNER JOIN sales.order_items oi
--         ON oi.product_id = p.product_id
--            AND oi.discount = md.max_discount
-- ORDER BY p.product_id

--TODO: Для каждого продукта, у которого цена больше 7000, найти все заказы, в которых скидка
--  равна минимально для этого конкретного продукта или максимальной для этого конкретного продукта
-- SELECT p.product_id,
--        MAX(oi.discount) as MAX,
--        MIN(oi.discount) as MIN
-- FROM [production].[products] as p
--     INNER JOIN [sales].[order_items] as oi on oi.product_id = p.product_id
--     INNER JOIN [sales].[orders] as o on oi.order_id = o.order_id
--     WHERE p.list_price > 7000
--     GROUP BY p.product_id


SELECT p.product_id, p.product_name, p.list_price, o.order_date from production.products as p
INNER JOIN sales.order_items as oi on p.product_id = oi.product_id
INNER JOIN sales.orders as o on o.order_id = oi.order_id
WHERE p.list_price > 7000 and 
(oi.discount in (select max(sales.order_items.discount) from sales.order_items group by sales.order_items.product_id) or 
oi.discount in (select min(sales.order_items.discount) from sales.order_items group by sales.order_items.product_id)) 



--TODO: Для каждого года выпуска продукта найдите топ 5 продуктов с самыми большими продажами
-- Продажи берем из деталей заказа, как разницу между list price и discount * list price.
-- SELECT p.model_year, p.product_id, p.product_name, (oi.list_price - oi.discount * oi.list_price) as sum_sales from production.products as p
-- INNER JOIN sales.order_items as oi on p.product_id = oi.product_id
-- GROUP BY p.product_id
-- ORDER BY sum_sales DESC


SELECT model_year, product_id, product_name, sum_sales from (
   select *, Rank() over (Partition BY model_year ORDER BY sum_sales DESC ) AS Rank from (
       SELECT p.model_year, p.product_id, p.product_name, (oi.list_price - oi.discount * oi.list_price) as sum_sales
    from production.products as p
    INNER JOIN sales.order_items as oi on p.product_id = oi.product_id) as tmp
) as res WHERE Rank <= 5 GROUP BY product_id

-- SELECT rs.Field1,rs.Field2 
--     FROM (
--         SELECT Field1,Field2, Rank()  over (Partition BY Section ORDER BY RankCriteria DESC ) AS Rank
--         FROM table
--         ) rs WHERE Rank <= 10