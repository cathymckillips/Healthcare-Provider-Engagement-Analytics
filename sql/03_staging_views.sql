USE HealthcareProviderEngagement;
GO
CREATE OR ALTER VIEW staging.vw_Regions AS
SELECT SourceRowID, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(RegionID)),'')) AS RegionID, TRY_CONVERT(varchar(2),NULLIF(LTRIM(RTRIM(StateCode)),'')) AS StateCode FROM raw.Regions;
GO
CREATE OR ALTER VIEW staging.vw_Specialties AS
SELECT SourceRowID, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(SpecialtyID)),'')) AS SpecialtyID, TRY_CONVERT(varchar(80),NULLIF(LTRIM(RTRIM(SpecialtyName)),'')) AS SpecialtyName FROM raw.Specialties;
GO
CREATE OR ALTER VIEW staging.vw_Organizations AS
SELECT SourceRowID, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(OrganizationID)),'')) AS OrganizationID, TRY_CONVERT(varchar(80),NULLIF(LTRIM(RTRIM(OrganizationName)),'')) AS OrganizationName FROM raw.Organizations;
GO
CREATE OR ALTER VIEW staging.vw_EngagementTypes AS
SELECT SourceRowID, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(EngagementTypeID)),'')) AS EngagementTypeID, TRY_CONVERT(varchar(80),NULLIF(LTRIM(RTRIM(EngagementTypeName)),'')) AS EngagementTypeName, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(IsQualifying)),'')) AS IsQualifying FROM raw.EngagementTypes;
GO
CREATE OR ALTER VIEW staging.vw_Providers AS
SELECT SourceRowID, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(ProviderID)),'')) AS ProviderID, TRY_CONVERT(varchar(80),NULLIF(LTRIM(RTRIM(ProviderName)),'')) AS ProviderName, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(SpecialtyID)),'')) AS SpecialtyID, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(OrganizationID)),'')) AS OrganizationID, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(RegionID)),'')) AS RegionID, TRY_CONVERT(date,NULLIF(LTRIM(RTRIM(RegistrationDate)),'')) AS RegistrationDate FROM raw.Providers;
GO
CREATE OR ALTER VIEW staging.vw_ProviderSessions AS
SELECT SourceRowID, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(SessionID)),'')) AS SessionID, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(ProviderID)),'')) AS ProviderID, TRY_CONVERT(datetime2,NULLIF(LTRIM(RTRIM(SessionStart)),'')) AS SessionStart, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(DurationMinutes)),'')) AS DurationMinutes FROM raw.ProviderSessions;
GO
CREATE OR ALTER VIEW staging.vw_ProviderEngagement AS
SELECT SourceRowID, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(EngagementID)),'')) AS EngagementID, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(ProviderID)),'')) AS ProviderID, TRY_CONVERT(int,NULLIF(LTRIM(RTRIM(EngagementTypeID)),'')) AS EngagementTypeID, TRY_CONVERT(datetime2,NULLIF(LTRIM(RTRIM(EngagementTimestamp)),'')) AS EngagementTimestamp FROM raw.ProviderEngagement;
GO
