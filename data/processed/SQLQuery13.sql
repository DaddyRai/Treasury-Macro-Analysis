SELECT TOP 20 *
FROM analytics.monthly_macro_market
ORDER BY month_date DESC;

SELECT *
FROM analytics.monthly_macro_market
WHERE yield_2y IS NULL
   OR yield_10y IS NULL
   OR fed_funds IS NULL
   OR cpi_index IS NULL
   OR unemployment_rate IS NULL
   OR sp500 IS NULL
ORDER BY month_date DESC;

SELECT TOP 10
    month_date,
    yield_2y,
    yield_10y,
    spread_10y_2y,
    spread_10y_2y_bps
FROM analytics.monthly_macro_market
WHERE spread_10y_2y IS NOT NULL
ORDER BY spread_10y_2y ASC;

SELECT
    curve_state,
    COUNT(*) AS months,
    AVG(sp500_monthly_return) AS avg_sp500_monthly_return
FROM analytics.monthly_macro_market
WHERE sp500_monthly_return IS NOT NULL
GROUP BY curve_state;