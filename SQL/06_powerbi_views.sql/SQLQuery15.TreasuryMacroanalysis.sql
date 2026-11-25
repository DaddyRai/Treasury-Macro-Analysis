CREATE OR ALTER VIEW analytics.yield_curve_long
AS

SELECT
    t.month_date,
    y.maturity,
    y.maturity_order,
    y.yield_value

FROM staging.treasury_monthly AS t

CROSS APPLY
(
    VALUES
        ('3M',  1, t.yield_3m),
        ('2Y',  2, t.yield_2y),
        ('5Y',  3, t.yield_5y),
        ('10Y', 4, t.yield_10y),
        ('30Y', 5, t.yield_30y)
) AS y (
    maturity,
    maturity_order,
    yield_value
)

WHERE t.month_date >= '2017-01-01';
GO

SELECT TOP 20 *
FROM analytics.yield_curve_long
ORDER BY month_date DESC, maturity_order;
GO

CREATE OR ALTER VIEW analytics.dim_month
AS

SELECT DISTINCT
    month_date,
    YEAR(month_date) AS year,
    MONTH(month_date) AS month_number,
    DATENAME(MONTH, month_date) AS month_name,
    DATEPART(QUARTER, month_date) AS quarter_number,

    CONCAT(
        YEAR(month_date),
        '-',
        RIGHT(
            '0' + CAST(MONTH(month_date) AS VARCHAR(2)),
            2
        )
    ) AS year_month

FROM analytics.monthly_macro_market;
GO

SELECT TOP 20 *
FROM analytics.dim_month
ORDER BY month_date DESC;