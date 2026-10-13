USE HealthcareProviderEngagement;
GO
CREATE OR ALTER VIEW reporting.vw_ProviderMonth AS
WITH months AS (
 SELECT DATEADD(month,n,CONVERT(date,'2024-01-01')) AS MonthStart
 FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),(31),(32)) m(n)
), events AS (
 SELECT e.* FROM governed.vw_ProviderEngagement e JOIN staging.vw_EngagementTypes t ON e.EngagementTypeID=t.EngagementTypeID WHERE t.IsQualifying=1
), firsts AS (
 SELECT ProviderID,MIN(EngagementTimestamp) AS FirstEngagement FROM events GROUP BY ProviderID
), counts AS (
 SELECT ProviderID,DATEFROMPARTS(YEAR(EngagementTimestamp),MONTH(EngagementTimestamp),1) AS MonthStart,COUNT(*) AS Engagements FROM events GROUP BY ProviderID,DATEFROMPARTS(YEAR(EngagementTimestamp),MONTH(EngagementTimestamp),1)
)
SELECT p.ProviderID,m.MonthStart,p.RegistrationDate,
 DATEFROMPARTS(YEAR(p.RegistrationDate),MONTH(p.RegistrationDate),1) AS RegistrationCohort,
 s.SpecialtyName,r.StateCode,o.OrganizationName,
 1 AS RegisteredFlag,
 CASE WHEN c.Engagements>0 THEN 1 ELSE 0 END AS ActiveFlag,
 ISNULL(c.Engagements,0) AS Engagements,
 ISNULL(prev.Engagements,0) AS PriorEngagements,
 CASE WHEN prev.Engagements>0 THEN 1 ELSE 0 END AS PriorActiveFlag,
 CASE WHEN c.Engagements>0 AND prev.Engagements>0 THEN 1 ELSE 0 END AS RetainedFlag,
 CASE WHEN f.FirstEngagement<DATEADD(month,1,m.MonthStart) THEN 1 ELSE 0 END AS ActivatedFlag,
 CASE WHEN p.RegistrationDate>=m.MonthStart THEN 1 ELSE 0 END AS NewRegistrationFlag,
 CASE WHEN f.FirstEngagement>=m.MonthStart AND f.FirstEngagement<DATEADD(month,1,m.MonthStart) THEN 1 ELSE 0 END AS FirstActiveFlag
FROM governed.vw_Providers p CROSS JOIN months m
JOIN staging.vw_Specialties s ON p.SpecialtyID=s.SpecialtyID
JOIN staging.vw_Regions r ON p.RegionID=r.RegionID
JOIN staging.vw_Organizations o ON p.OrganizationID=o.OrganizationID
LEFT JOIN firsts f ON p.ProviderID=f.ProviderID
LEFT JOIN counts c ON p.ProviderID=c.ProviderID AND m.MonthStart=c.MonthStart
LEFT JOIN counts prev ON p.ProviderID=prev.ProviderID AND prev.MonthStart=DATEADD(month,-1,m.MonthStart)
WHERE p.RegistrationDate<DATEADD(month,1,m.MonthStart);
GO
CREATE OR ALTER VIEW reporting.vw_EngagementDetail AS
SELECT e.EngagementID,e.ProviderID,e.EngagementTimestamp,t.EngagementTypeName,t.IsQualifying,s.SpecialtyName,r.StateCode
FROM governed.vw_ProviderEngagement e
JOIN governed.vw_Providers p ON e.ProviderID=p.ProviderID
JOIN staging.vw_EngagementTypes t ON e.EngagementTypeID=t.EngagementTypeID
JOIN staging.vw_Specialties s ON p.SpecialtyID=s.SpecialtyID
JOIN staging.vw_Regions r ON p.RegionID=r.RegionID;
GO
CREATE OR ALTER VIEW reporting.vw_DataQualitySummary AS
WITH src AS (
 SELECT 'Providers' AS SourceTable,COUNT(*) AS TotalRecords FROM raw.Providers UNION ALL
 SELECT 'ProviderEngagement',COUNT(*) FROM raw.ProviderEngagement UNION ALL
 SELECT 'ProviderSessions',COUNT(*) FROM raw.ProviderSessions
), bad AS (
 SELECT SourceTable,COUNT(DISTINCT SourceRowID) AS RecordsWithExceptions,COUNT(*) AS RuleFailures FROM reporting.vw_DataQualityExceptions GROUP BY SourceTable
)
SELECT s.SourceTable,s.TotalRecords,ISNULL(b.RecordsWithExceptions,0) AS RecordsWithExceptions,s.TotalRecords-ISNULL(b.RecordsWithExceptions,0) AS PassedRecords,ISNULL(b.RuleFailures,0) AS RuleFailures FROM src s LEFT JOIN bad b ON s.SourceTable=b.SourceTable;
GO
