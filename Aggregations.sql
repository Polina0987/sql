--Функции аггрегации (Aggregation functions)
SELECT MAX([list_price])
FROM [production].[products]

SELECT MIN(model_year)
FROM [production].[products]

--Group by (non-aggreagte columns always should be present in the group by clause)
SELECT model_year,
       SUM([list_price])
FROM [production].[products]
GROUP BY model_year

--Having
SELECT model_year,
       MAX([list_price]),
       AVG([list_price])
FROM [production].[products]
GROUP BY model_year
HAVING MAX([list_price]) >= 6499.99

--Оконные функции (Window Functions)
SELECT model_year,
       [list_price],
       SUM([list_price]) OVER () AS total_sum
FROM [production].[products]

SELECT model_year,
       [list_price],
       SUM([list_price]) OVER (PARTITION BY model_year) AS partition_sum
FROM [production].[products]
ORDER BY model_year,
         [list_price]

SELECT model_year,
       [list_price],
       SUM([list_price]) OVER (PARTITION BY model_year ORDER BY [list_price] DESC) AS cumulative_sum
FROM [production].[products]
ORDER BY model_year,
         [list_price] DESC

-- Порядок выполнения

SELECT model_year AS myear,
       MAX([list_price]) AS max_price,
       AVG([list_price]) AS avg_price
FROM [production].[products]
WHERE model_year IN ( 2017, 2018 )
GROUP BY model_year
HAVING MAX([list_price]) >= 6499.99
ORDER BY myear


--TODO: Find average list_price per model_year of all products with list_price more or equal than 832.99 and min list_price more than 850
SELECT model_year,
       AVG([list_price]) AS avg_list_price
FROM [production].[products]
GROUP BY model_year
HAVING MAX([list_price]) >= 832.99
   AND MIN ([list_price]) > 850
