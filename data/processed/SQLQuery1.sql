SELECT TOP 10 *
FROM raw.treasury_2y;

SELECT *
FROM raw.treasury_2y
ORDER BY observation_date DESC;

SELECT COUNT(*) AS total_rows
FROM raw.treasury_2y;

SELECT COUNT(*) AS rows_3m
FROM raw.treasury_3m;

SELECT COUNT(*) AS rows_2y
FROM raw.treasury_2y;

SELECT COUNT(*) AS rows_5y
FROM raw.treasury_5y;

SELECT COUNT(*) AS rows_10y
FROM raw.treasury_10y;

SELECT COUNT(*) AS rows_30y
FROM raw.treasury_30y;

