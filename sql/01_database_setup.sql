USE master;
GO
IF DB_ID('HealthcareProviderEngagement') IS NULL CREATE DATABASE HealthcareProviderEngagement;
GO
USE HealthcareProviderEngagement;
GO
IF SCHEMA_ID('raw') IS NULL EXEC('CREATE SCHEMA raw');
GO
IF SCHEMA_ID('staging') IS NULL EXEC('CREATE SCHEMA staging');
GO
IF SCHEMA_ID('governed') IS NULL EXEC('CREATE SCHEMA governed');
GO
IF SCHEMA_ID('reporting') IS NULL EXEC('CREATE SCHEMA reporting');
GO
