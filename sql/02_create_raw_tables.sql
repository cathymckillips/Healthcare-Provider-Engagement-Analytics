USE HealthcareProviderEngagement;
GO
IF OBJECT_ID('raw.Regions') IS NULL
CREATE TABLE raw.Regions (SourceRowID int IDENTITY(1,1) PRIMARY KEY, RegionID varchar(100) NULL, StateCode varchar(100) NULL);
GO
IF OBJECT_ID('raw.Specialties') IS NULL
CREATE TABLE raw.Specialties (SourceRowID int IDENTITY(1,1) PRIMARY KEY, SpecialtyID varchar(100) NULL, SpecialtyName varchar(100) NULL);
GO
IF OBJECT_ID('raw.Organizations') IS NULL
CREATE TABLE raw.Organizations (SourceRowID int IDENTITY(1,1) PRIMARY KEY, OrganizationID varchar(100) NULL, OrganizationName varchar(100) NULL);
GO
IF OBJECT_ID('raw.EngagementTypes') IS NULL
CREATE TABLE raw.EngagementTypes (SourceRowID int IDENTITY(1,1) PRIMARY KEY, EngagementTypeID varchar(100) NULL, EngagementTypeName varchar(100) NULL, IsQualifying varchar(100) NULL);
GO
IF OBJECT_ID('raw.Providers') IS NULL
CREATE TABLE raw.Providers (SourceRowID int IDENTITY(1,1) PRIMARY KEY, ProviderID varchar(100) NULL, ProviderName varchar(100) NULL, SpecialtyID varchar(100) NULL, OrganizationID varchar(100) NULL, RegionID varchar(100) NULL, RegistrationDate varchar(100) NULL);
GO
IF OBJECT_ID('raw.ProviderSessions') IS NULL
CREATE TABLE raw.ProviderSessions (SourceRowID int IDENTITY(1,1) PRIMARY KEY, SessionID varchar(100) NULL, ProviderID varchar(100) NULL, SessionStart varchar(100) NULL, DurationMinutes varchar(100) NULL);
GO
IF OBJECT_ID('raw.ProviderEngagement') IS NULL
CREATE TABLE raw.ProviderEngagement (SourceRowID int IDENTITY(1,1) PRIMARY KEY, EngagementID varchar(100) NULL, ProviderID varchar(100) NULL, EngagementTypeID varchar(100) NULL, EngagementTimestamp varchar(100) NULL);
GO
