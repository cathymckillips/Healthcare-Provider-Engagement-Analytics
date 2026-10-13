USE HealthcareProviderEngagement;
GO
SELECT 'ProviderMonth' AS Dataset, COUNT(*) AS Rows FROM reporting.vw_ProviderMonth;
SELECT MonthStart,SUM(RegisteredFlag) AS RegisteredProviders,SUM(ActiveFlag) AS ActiveProviders,SUM(Engagements) AS QualifyingEngagements,SUM(ActivatedFlag) AS ActivatedProviders,SUM(PriorActiveFlag) AS PriorActiveProviders,SUM(RetainedFlag) AS RetainedProviders FROM reporting.vw_ProviderMonth GROUP BY MonthStart ORDER BY MonthStart;
SELECT * FROM reporting.vw_DataQualitySummary;
SELECT RuleID,COUNT(*) AS Failures FROM reporting.vw_DataQualityExceptions GROUP BY RuleID ORDER BY RuleID;
-- Should return zero for each Difference:
SELECT (SELECT SUM(Engagements) FROM reporting.vw_ProviderMonth)-(SELECT COUNT(*) FROM reporting.vw_EngagementDetail WHERE IsQualifying=1) AS EngagementDifference;
SELECT COUNT(*) AS InvalidRetentionRows FROM reporting.vw_ProviderMonth WHERE RetainedFlag>PriorActiveFlag;
SELECT COUNT(*) AS DuplicateProviderMonthKeys FROM (SELECT ProviderID,MonthStart FROM reporting.vw_ProviderMonth GROUP BY ProviderID,MonthStart HAVING COUNT(*)>1) d;
