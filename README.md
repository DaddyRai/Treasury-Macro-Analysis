# Treasury Yields & Macroeconomic Market Conditions

**SQL (Azure) | Power BI | FRED | Time-Series Analysis**

## Overview

This project explores how **Treasury yields, Federal Reserve monetary policy, inflation, unemployment, the Fed balance sheet, and the S&P 500** move across different market conditions. I prepared economic and market time series in SQL, aligned them at a monthly frequency, and built a multi-page Power BI dashboard for macroeconomic research.

**Period covered:** September 2017-2026

## Research Questions

- How did short- and long-maturity Treasury yields respond during different monetary-policy environments?
During the 2022 tightening cycle, the Federal Reserve increased its target interest-rate range by 425 basis points, from 0.00%–0.25% to 4.25%–4.50%. My SQL project is designed to compare changes in 2 year and 10 year Treasury yields alongside the effective federal funds rate. The exact differences between those yields still need to be confirmed from your database.

- When did the **10-year minus 2-year (10Y–2Y)** and **10-year minus 3-month (10Y–3M)** yield spreads invert?
On July 6, 2022, the daily 10Y–2Y spread reached 4 basis points. The 10Y–3M spread also reached 4 basis points on October 25, 2022, beginning a more sustained inversion.

- How did inflation, unemployment, and the Federal Reserve balance sheet change alongside interest rates?
U.S. consumer inflation reached 9.1% year over year in June 2022. Unemployment remained relatively low, at 3.6% in May 2022, while the Federal Reserve began shrinking its balance sheet in June.

- What patterns appeared between monthly S&P 500 returns and macroeconomic indicators?
During September 2022, the S&P 500 fell from 3,955.00 to 3,585.62, a monthly price decline of 9.34%. The decline occurred amid rising interest rates and inflation concerns.

## Tools & Methods

- **Azure SQL / SQL Server:** Cleaning, joins, monthly alignment, analytical views, and window functions such as `LAG()`.
- **Power BI:** Interactive report pages, DAX measures, slicers, and month-specific tooltips.
- **Analysis:** Yield spreads, inversion flags, year-over-year CPI inflation, monthly S&P 500 changes, and policy-rate trends.

## Data Sources

Primary data source: [Federal Reserve Economic Data (FRED)](https://fred.stlouisfed.org/).

| Series | Indicator |
| --- | --- |
| `GS3M`, `GS2`, `GS5`, `GS10`, `GS30` | Treasury yields by maturity |
| `FEDFUNDS` | Effective federal funds rate |
| `CPIAUCSL` | Consumer Price Index |
| `UNRATE` | Unemployment rate |
| `WALCL` | Federal Reserve total assets |
| `SP500` | S&P 500 index |

Data from different original frequencies were aligned to monthly observations. In the project workflow, the S&P 500 uses the last available trading observation per month and weekly Fed total assets are aggregated to a monthly series. Document the precise aggregation method used in your SQL.

## SQL Processing & Derived Indicators

The pipeline stages source series, standardizes dates, handles missing observations, joins monthly records, and produces reporting-ready metrics. A central analytical view used in development is `analytics.monthly_macro_market`.

| Calculation | Definition |
| --- | --- |
| 10Y–2Y spread | 10-year yield minus 2-year yield |
| 10Y–3M spread | 10-year yield minus 3-month yield |
| Inversion flag | Spread is below zero |
| YoY CPI inflation | CPI percentage change versus 12 months earlier |
| S&P 500 monthly return | Percent change in monthly index level |
| Monthly yield change | Current yield minus prior month's yield |

## Power BI Dashboard

### Macro Overview
High-level comparison of interest rates, inflation, unemployment, and financial market conditions.
<img width="1359" height="768" alt="image" src="https://github.com/user-attachments/assets/cba24638-f450-44ff-a172-b68cb3190968" />

### Fed & Rates
Federal funds rate, Treasury yields, and Federal Reserve balance-sheet developments.
<img width="1358" height="769" alt="image" src="https://github.com/user-attachments/assets/6050f4a8-4d45-4dad-9708-644b89acc1aa" />

### Curve Signals
10Y–2Y and 10Y–3M yield spreads, inversion periods, and term-structure signals.
<img width="1364" height="774" alt="image" src="https://github.com/user-attachments/assets/0f3be83d-7d73-44cf-9966-63c0b21258e7" />

### Markets
S&P 500 monthly performance viewed alongside macroeconomic data.
<img width="1376" height="778" alt="image" src="https://github.com/user-attachments/assets/49c97ca7-912b-4a43-8315-e495fc9ecb04" />

## Key Findings

1. **Yield curve: Inversion During 2022** 
The U.S. Treasury yield curve inverted during the Federal Reserve's monetary tightening cycle. In July 2022, the monthly 10 year minus 2-year Treasury spread reached 0.14 percentage points (14 basis points), deepening to 0.67 percentage points (67 basis points) by December 2022. This reflected short-term Treasury yields exceeding long-term yields, a historically important recession-risk indicator.

2. **Monetary policy: Rising Rates & Treasury Yields** 
During 2022, the Federal Reserve increased its target federal funds range by 425 basis points, from 0.00%–0.25% to 4.25%–4.50%. Over the same January–December period, the monthly average 2 year Treasury yield increased from 0.98% to 4.29%, while the 10 year yield rose from 1.76% to 3.62%. The larger increase in short-term yields contributed to yield-curve inversion.

3. **Equities: S&P 500 Decline During Tightening** 
In September 2022, the S&P 500 declined from 3,955.00 on August 31 to 3,585.62 on September 30, representing a 9.34% monthly price return. This occurred during a period of aggressive monetary tightening and elevated inflation, illustrating how equity market weakness and changing macroeconomic conditions can coincide.

4. **Interpretation: Macroeconomic Risk Indicators** 
The historical evidence demonstrates that Federal Reserve tightening, Treasury yield-curve inversion, and declining equity prices occurred during overlapping periods of economic uncertainty. These findings support using yield spreads, inflation, policy rates, and market returns together to monitor macroeconomic conditions. However, the analysis is descriptive: yield-curve inversion does not guarantee a recession, and correlation does not establish causation.


## How to Explore / Reproduce

1. Retrieve the relevant FRED series, respecting data-provider terms.
2. Run the SQL staging and transformation scripts in the documented order.
3. Validate the monthly analytical view and derived metrics.
4. Open the report in Power BI Desktop; reconnect data sources if needed.

## Limitations

Series have different original frequencies and can be revised after publication. Monthly aggregation hides daily and intramonth variation. Yield-curve inversion is a historical indicator, **not a deterministic recession forecast**, and correlations in charts do not demonstrate causality. Results depend on the selected date range and data definitions.

## Project Goal

Demonstrate reproducible SQL-based time-series analysis, macroeconomic reasoning, and clear communication of complex market data through Power BI.
