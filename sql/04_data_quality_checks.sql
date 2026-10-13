USE HealthcareProviderEngagement;
GO
CREATE OR ALTER VIEW reporting.vw_DataQualityExceptions AS
SELECT 'DQ01' AS RuleID, 'ProviderEngagement' AS SourceTable, x.SourceRowID, 'Missing or malformed provider ID' AS Issue FROM staging.vw_ProviderEngagement x WHERE x.ProviderID IS NULL
UNION ALL
SELECT 'DQ02' AS RuleID, 'ProviderEngagement' AS SourceTable, x.SourceRowID, 'Unknown provider ID' AS Issue FROM staging.vw_ProviderEngagement x WHERE x.ProviderID IS NOT NULL AND NOT EXISTS (SELECT 1 FROM staging.vw_Providers p WHERE p.ProviderID=x.ProviderID)
UNION ALL
SELECT 'DQ03' AS RuleID, 'ProviderEngagement' AS SourceTable, x.SourceRowID, 'Event after reporting cutoff' AS Issue FROM staging.vw_ProviderEngagement x WHERE x.EngagementTimestamp >= '2026-10-01'
UNION ALL
SELECT 'DQ04' AS RuleID, 'ProviderEngagement' AS SourceTable, x.SourceRowID, 'Invalid engagement type' AS Issue FROM staging.vw_ProviderEngagement x WHERE NOT EXISTS (SELECT 1 FROM staging.vw_EngagementTypes t WHERE t.EngagementTypeID=x.EngagementTypeID)
UNION ALL
SELECT 'DQ05' AS RuleID, 'ProviderEngagement' AS SourceTable, x.SourceRowID, 'Event before registration' AS Issue FROM staging.vw_ProviderEngagement x WHERE EXISTS (SELECT 1 FROM staging.vw_Providers p WHERE p.ProviderID=x.ProviderID AND x.EngagementTimestamp < p.RegistrationDate)
UNION ALL
SELECT 'DQ06' AS RuleID, 'Providers' AS SourceTable, x.SourceRowID, 'Missing or duplicate provider key' AS Issue FROM staging.vw_Providers x WHERE x.ProviderID IS NULL OR EXISTS (SELECT 1 FROM staging.vw_Providers p WHERE p.ProviderID=x.ProviderID AND p.SourceRowID<>x.SourceRowID)
UNION ALL
SELECT 'DQ07' AS RuleID, 'Providers' AS SourceTable, x.SourceRowID, 'Invalid specialty' AS Issue FROM staging.vw_Providers x WHERE NOT EXISTS (SELECT 1 FROM staging.vw_Specialties s WHERE s.SpecialtyID=x.SpecialtyID)
UNION ALL
SELECT 'DQ08' AS RuleID, 'ProviderSessions' AS SourceTable, x.SourceRowID, 'Missing or negative session duration' AS Issue FROM staging.vw_ProviderSessions x WHERE x.DurationMinutes IS NULL OR x.DurationMinutes<0
UNION ALL
SELECT 'DQ09' AS RuleID, 'ProviderEngagement' AS SourceTable, x.SourceRowID, 'Missing or malformed event timestamp' AS Issue FROM staging.vw_ProviderEngagement x WHERE x.EngagementTimestamp IS NULL
UNION ALL
SELECT 'DQ10' AS RuleID, 'Providers' AS SourceTable, x.SourceRowID, 'Invalid organization' AS Issue FROM staging.vw_Providers x WHERE NOT EXISTS (SELECT 1 FROM staging.vw_Organizations o WHERE o.OrganizationID=x.OrganizationID)
UNION ALL
SELECT 'DQ11' AS RuleID, 'ProviderEngagement' AS SourceTable, x.SourceRowID, 'Missing event key or later duplicate event' AS Issue FROM staging.vw_ProviderEngagement x WHERE x.EngagementID IS NULL OR EXISTS (SELECT 1 FROM staging.vw_ProviderEngagement e WHERE e.EngagementID=x.EngagementID AND e.SourceRowID<x.SourceRowID)
UNION ALL
SELECT 'DQ12' AS RuleID, 'Providers' AS SourceTable, x.SourceRowID, 'Invalid state reference' AS Issue FROM staging.vw_Providers x WHERE NOT EXISTS (SELECT 1 FROM staging.vw_Regions r WHERE r.RegionID=x.RegionID)
UNION ALL
SELECT 'DQ13' AS RuleID, 'Providers' AS SourceTable, x.SourceRowID, 'Registration outside coverage or missing' AS Issue FROM staging.vw_Providers x WHERE x.RegistrationDate IS NULL OR x.RegistrationDate<'2024-01-01' OR x.RegistrationDate>='2026-10-01'
UNION ALL
SELECT 'DQ14' AS RuleID, 'ProviderSessions' AS SourceTable, x.SourceRowID, 'Unknown session provider' AS Issue FROM staging.vw_ProviderSessions x WHERE NOT EXISTS (SELECT 1 FROM staging.vw_Providers p WHERE p.ProviderID=x.ProviderID)
UNION ALL
SELECT 'DQ15' AS RuleID, 'ProviderSessions' AS SourceTable, x.SourceRowID, 'Invalid session timestamp' AS Issue FROM staging.vw_ProviderSessions x WHERE x.SessionStart IS NULL OR x.SessionStart<'2024-01-01' OR x.SessionStart>='2026-10-01' OR EXISTS (SELECT 1 FROM staging.vw_Providers p WHERE p.ProviderID=x.ProviderID AND x.SessionStart<p.RegistrationDate)
UNION ALL
SELECT 'DQ16' AS RuleID, 'ProviderSessions' AS SourceTable, x.SourceRowID, 'Missing session key or later duplicate' AS Issue FROM staging.vw_ProviderSessions x WHERE x.SessionID IS NULL OR EXISTS (SELECT 1 FROM staging.vw_ProviderSessions s WHERE s.SessionID=x.SessionID AND s.SourceRowID<x.SourceRowID)
UNION ALL
SELECT 'DQ17' AS RuleID, 'ProviderEngagement' AS SourceTable, x.SourceRowID, 'Event before coverage' AS Issue FROM staging.vw_ProviderEngagement x WHERE x.EngagementTimestamp<'2024-01-01';
GO
