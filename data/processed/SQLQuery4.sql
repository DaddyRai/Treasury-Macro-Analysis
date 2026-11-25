CREATE OR ALTER VIEW staging.treasury_monthly
AS

SELECT
    t2.observation_date AS month_date,

    CAST(t3.GS3M AS DECIMAL(6,3)) AS yield_3m,
    CAST(t2.GS2 AS DECIMAL(6,3)) AS yield_2y,
    CAST(t5.GS5 AS DECIMAL(6,3)) AS yield_5y,
    CAST(t10.GS10 AS DECIMAL(6,3)) AS yield_10y,
    CAST(t30.GS30 AS DECIMAL(6,3)) AS yield_30y

FROM raw.treasury_2y AS t2

LEFT JOIN staging.treasury_3m_clean AS t3
    ON t2.observation_date = t3.observation_date

LEFT JOIN raw.treasury_5y AS t5
    ON t2.observation_date = t5.observation_date

LEFT JOIN raw.treasury_10y AS t10
    ON t2.observation_date = t10.observation_date

LEFT JOIN raw.treasury_30y AS t30
    ON t2.observation_date = t30.observation_date;
GO

SELECT TOP 20 *
FROM staging.treasury_monthly
ORDER BY month_date DESC;