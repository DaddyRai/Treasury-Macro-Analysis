SELECT
    TABLE_NAME,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'raw'
  AND TABLE_NAME IN (
        'fed_funds',
        'fed_assets',
        'cpi',
        'unemployment',
        'sp500'
    )
ORDER BY TABLE_NAME, ORDINAL_POSITION;