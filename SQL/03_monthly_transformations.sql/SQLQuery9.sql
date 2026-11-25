CREATE OR ALTER VIEW staging.fed_policy_monthly
AS

WITH assets_ranked AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(observation_date),
            MONTH(observation_date),
            1
        ) AS month_date,

        observation_date,

        CAST(WALCL AS DECIMAL(18,2)) AS fed_assets_millions,

        ROW_NUMBER() OVER
        (
            PARTITION BY
                YEAR(observation_date),
                MONTH(observation_date)

            ORDER BY observation_date DESC
        ) AS rn

    FROM raw.fed_assets
),

assets_monthly AS
(
    SELECT
        month_date,
        fed_assets_millions
    FROM assets_ranked
    WHERE rn = 1
)

SELECT
    DATEFROMPARTS(
        YEAR(f.observation_date),
        MONTH(f.observation_date),
        1
    ) AS month_date,

    CAST(f.FEDFUNDS AS DECIMAL(6,3)) AS fed_funds,

    a.fed_assets_millions

FROM raw.fed_funds AS f

LEFT JOIN assets_monthly AS a
    ON DATEFROMPARTS(
        YEAR(f.observation_date),
        MONTH(f.observation_date),
        1
    ) = a.month_date;
GO

CREATE OR ALTER VIEW staging.macro_monthly
AS

SELECT
    DATEFROMPARTS(
        YEAR(c.observation_date),
        MONTH(c.observation_date),
        1
    ) AS month_date,

    CAST(c.CPIAUCSL AS DECIMAL(12,3)) AS cpi_index,

    CAST(u.UNRATE AS DECIMAL(6,3)) AS unemployment_rate

FROM raw.cpi AS c

LEFT JOIN raw.unemployment AS u
    ON DATEFROMPARTS(
        YEAR(c.observation_date),
        MONTH(c.observation_date),
        1
    )
    =
    DATEFROMPARTS(
        YEAR(u.observation_date),
        MONTH(u.observation_date),
        1
    );
GO

CREATE OR ALTER VIEW staging.sp500_monthly
AS

WITH ranked_prices AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(observation_date),
            MONTH(observation_date),
            1
        ) AS month_date,

        observation_date,

        CAST(SP500 AS DECIMAL(12,4)) AS sp500,

        ROW_NUMBER() OVER
        (
            PARTITION BY
                YEAR(observation_date),
                MONTH(observation_date)

            ORDER BY observation_date DESC
        ) AS rn

    FROM raw.sp500
)

SELECT
    month_date,
    observation_date AS month_end_trading_date,
    sp500

FROM ranked_prices

WHERE rn = 1;
GO

USE TreasuryMacroAnalysis;
GO


SELECT TOP 5 *
FROM staging.treasury_monthly
ORDER BY month_date DESC;

SELECT TOP 5 *
FROM staging.fed_policy_monthly
ORDER BY month_date DESC;

SELECT TOP 5 *
FROM staging.macro_monthly
ORDER BY month_date DESC;

SELECT TOP 5 *
FROM staging.sp500_monthly
ORDER BY month_date DESC;

USE TreasuryMacroAnalysis;
GO

CREATE OR ALTER VIEW analytics.monthly_macro_market
AS

WITH base AS
(
    SELECT
        t.month_date,

        -- Treasury yields
        t.yield_3m,
        t.yield_2y,
        t.yield_5y,
        t.yield_10y,
        t.yield_30y,

        -- Fed policy
        f.fed_funds,
        f.fed_assets_millions,

        -- Macro
        m.cpi_index,
        m.unemployment_rate,

        -- Market
        s.sp500

    FROM staging.treasury_monthly AS t

    LEFT JOIN staging.fed_policy_monthly AS f
        ON t.month_date = f.month_date

    LEFT JOIN staging.macro_monthly AS m
        ON t.month_date = m.month_date

    LEFT JOIN staging.sp500_monthly AS s
        ON t.month_date = s.month_date
),

lagged AS
(
    SELECT
        *,

        LAG(sp500, 1)
            OVER (ORDER BY month_date)
            AS previous_sp500,

        LAG(cpi_index, 12)
            OVER (ORDER BY month_date)
            AS cpi_12_months_ago,

        LAG(yield_2y, 1)
            OVER (ORDER BY month_date)
            AS previous_yield_2y,

        LAG(yield_10y, 1)
            OVER (ORDER BY month_date)
            AS previous_yield_10y,

        LAG(fed_funds, 1)
            OVER (ORDER BY month_date)
            AS previous_fed_funds,

        LAG(fed_assets_millions, 1)
            OVER (ORDER BY month_date)
            AS previous_fed_assets

    FROM base
)

SELECT
    month_date,

    -- Treasury yields
    yield_3m,
    yield_2y,
    yield_5y,
    yield_10y,
    yield_30y,

    -- Yield curve spreads
    CAST(
        yield_10y - yield_2y
        AS DECIMAL(7,3)
    ) AS spread_10y_2y,

    CAST(
        (yield_10y - yield_2y) * 100
        AS DECIMAL(8,1)
    ) AS spread_10y_2y_bps,

    CAST(
        yield_10y - yield_3m
        AS DECIMAL(7,3)
    ) AS spread_10y_3m,

    -- Fed Funds
    fed_funds,

    CAST(
        (fed_funds - previous_fed_funds) * 100
        AS DECIMAL(8,1)
    ) AS fed_funds_change_bps,

    -- Fed balance sheet
    fed_assets_millions,

    CAST(
        fed_assets_millions - previous_fed_assets
        AS DECIMAL(18,2)
    ) AS fed_assets_change_millions,

    CAST(
        fed_assets_millions /
        NULLIF(previous_fed_assets, 0) - 1
        AS DECIMAL(12,8)
    ) AS fed_assets_change_pct,

    -- Inflation / labor
    cpi_index,

    CAST(
        cpi_index /
        NULLIF(cpi_12_months_ago, 0) - 1
        AS DECIMAL(12,8)
    ) AS inflation_yoy,

    unemployment_rate,

    -- S&P 500
    sp500,

    CAST(
        sp500 /
        NULLIF(previous_sp500, 0) - 1
        AS DECIMAL(12,8)
    ) AS sp500_monthly_return,

    -- Treasury monthly movements
    CAST(
        (yield_2y - previous_yield_2y) * 100
        AS DECIMAL(8,1)
    ) AS yield_2y_change_bps,

    CAST(
        (yield_10y - previous_yield_10y) * 100
        AS DECIMAL(8,1)
    ) AS yield_10y_change_bps,

    -- Yield curve classification
    CASE
        WHEN yield_10y - yield_2y < 0
            THEN 'Inverted'

        WHEN yield_10y - yield_2y > 0
            THEN 'Positive'

        ELSE 'Flat'
    END AS curve_state,

    -- Fed rate direction
    CASE
        WHEN fed_funds > previous_fed_funds
            THEN 'Increasing'

        WHEN fed_funds < previous_fed_funds
            THEN 'Decreasing'

        ELSE 'Unchanged'
    END AS fed_funds_direction

FROM lagged

WHERE month_date >= '2017-01-01';
GO