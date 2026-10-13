USE HealthcareProviderEngagement;
GO

-- Raw source data
CREATE SCHEMA raw;
GO

-- Data cleaning and standardization
CREATE SCHEMA staging;
GO

-- Validated and governed data
CREATE SCHEMA governed;
GO

-- Tableau reporting datasets
CREATE SCHEMA reporting;
GO