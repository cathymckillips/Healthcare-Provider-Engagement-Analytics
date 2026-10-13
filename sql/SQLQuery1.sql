USE master;
GO

IF DB_ID('HealthcareProviderEngagement') IS NULL
BEGIN
    CREATE DATABASE HealthcareProviderEngagement;
END;
GO

USE HealthcareProviderEngagement;
GO