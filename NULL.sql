SELECT *
FROM [sales].[stores]

SELECT *
FROM [sales].[stores]
WHERE phone = NULL

SELECT *
FROM [sales].[stores]
WHERE phone <> NULL

SELECT *
FROM [sales].[stores]
WHERE phone IS NULL
SELECT *
FROM [sales].[stores]
WHERE phone IS NOT NULL

SELECT *
FROM [sales].[stores]
WHERE phone <> '(972) 530-5555'

SELECT COUNT(phone)
FROM [sales].[stores]

SELECT *
FROM [sales].[stores]
SELECT SUM(CAST(zip_code AS INT)),
       11432 + 75088
FROM [sales].[stores]

SELECT AVG(CAST(zip_code AS INT)),
       (11432 + 75088) / 3,
       (11432 + 75088) / 2
FROM [sales].[stores]

SELECT AVG(ISNULL(CAST(zip_code AS INT), 0)),
       (11432 + 75088) / 3,
       (11432 + 75088) / 2
FROM [sales].[stores]




