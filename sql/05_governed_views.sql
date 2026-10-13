USE HealthcareProviderEngagement;
GO
CREATE OR ALTER VIEW governed.vw_Providers AS SELECT x.* FROM staging.vw_Providers x WHERE NOT EXISTS (SELECT 1 FROM reporting.vw_DataQualityExceptions q WHERE q.SourceTable='Providers' AND q.SourceRowID=x.SourceRowID);
GO
CREATE OR ALTER VIEW governed.vw_ProviderEngagement AS SELECT x.* FROM staging.vw_ProviderEngagement x WHERE NOT EXISTS (SELECT 1 FROM reporting.vw_DataQualityExceptions q WHERE q.SourceTable='ProviderEngagement' AND q.SourceRowID=x.SourceRowID) AND EXISTS (SELECT 1 FROM governed.vw_Providers p WHERE p.ProviderID=x.ProviderID);
GO
CREATE OR ALTER VIEW governed.vw_ProviderSessions AS SELECT x.* FROM staging.vw_ProviderSessions x WHERE NOT EXISTS (SELECT 1 FROM reporting.vw_DataQualityExceptions q WHERE q.SourceTable='ProviderSessions' AND q.SourceRowID=x.SourceRowID) AND EXISTS (SELECT 1 FROM governed.vw_Providers p WHERE p.ProviderID=x.ProviderID);
GO
