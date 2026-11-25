USE TreasuryMacroAnalysis;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'raw'
)
EXEC('CREATE SCHEMA raw');
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'staging'
)
EXEC('CREATE SCHEMA staging');
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'analytics'
)
EXEC('CREATE SCHEMA analytics');
GO

SELECT name
FROM sys.schemas
WHERE name IN ('raw', 'staging', 'analytics');