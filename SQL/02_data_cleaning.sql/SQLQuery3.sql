SELECT TOP 5 *
FROM raw.treasury_3m;
GO

CREATE OR ALTER VIEW staging.treasury_3m_clean
AS
SELECT
    TRY_CONVERT(DATE, column1) AS observation_date,
    TRY_CONVERT(DECIMAL(6,3), column2) AS GS3M
FROM raw.treasury_3m
WHERE TRY_CONVERT(DATE, column1) IS NOT NULL;
GO

SELECT TOP 10 *
FROM staging.treasury_3m_clean;
GO

SELECT
    '3M' AS maturity,
    COUNT(*) AS total_rows,
    MIN(observation_date) AS first_date,
    MAX(observation_date) AS last_date
FROM staging.treasury_3m_clean

UNION ALL

SELECT
    '2Y',
    COUNT(*),
    MIN(observation_date),
    MAX(observation_date)
FROM raw.treasury_2y

UNION ALL

SELECT
    '5Y',
    COUNT(*),
    MIN(observation_date),
    MAX(observation_date)
FROM raw.treasury_5y

UNION ALL

SELECT
    '10Y',
    COUNT(*),
    MIN(observation_date),
    MAX(observation_date)
FROM raw.treasury_10y

UNION ALL

SELECT
    '30Y',
    COUNT(*),
    MIN(observation_date),
    MAX(observation_date)
FROM raw.treasury_30y;