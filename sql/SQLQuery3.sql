USE HealthcareProviderEngagement;
GO

SELECT
    name AS SchemaName,
    schema_id AS SchemaID
FROM sys.schemas
WHERE name IN (
    'raw',
    'staging',
    'governed',
    'reporting'
)
ORDER BY name;