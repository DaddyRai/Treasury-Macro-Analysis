SELECT TOP 20 *
FROM analytics.monthly_macro_market
ORDER BY month_date DESC;

SELECT
	month_date,
	COUNT(*) AS rows_per_month
FROM analytics.monthly_macro_market
GROUP BY month_date
HAVING COUNT(*) > 1;

SELECT *
FROM analytics.monthly_macro_market
WHERE yield_2y IS NULL
   OR yield_10y IS NULL
   OR fed_funds IS NULL
   OR cpi_index IS NULL
   OR unemployment_rate IS NULL
   OR sp500 IS NULL
ORDER BY month_date DESC;