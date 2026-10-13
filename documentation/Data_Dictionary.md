# Data dictionary

Raw fields are nullable varchar(100) to preserve invalid source values. SourceRowID is an ingestion surrogate key. Staging uses TRY_CONVERT; governed views reject flagged rows.

## Regions

| Field | Staging type | Meaning |
|---|---|---|
| RegionID | int | State reference key, not a sales region |
| StateCode | varchar(2) | StateCode |

## Specialties

| Field | Staging type | Meaning |
|---|---|---|
| SpecialtyID | int | Specialty reference key |
| SpecialtyName | varchar(80) | SpecialtyName |

## Organizations

| Field | Staging type | Meaning |
|---|---|---|
| OrganizationID | int | Organization reference key |
| OrganizationName | varchar(80) | OrganizationName |

## EngagementTypes

| Field | Staging type | Meaning |
|---|---|---|
| EngagementTypeID | int | EngagementType reference key |
| EngagementTypeName | varchar(80) | EngagementTypeName |
| IsQualifying | int | 1 counts for engagement, 0 general activity |

## Providers

| Field | Staging type | Meaning |
|---|---|---|
| ProviderID | int | Synthetic provider business key |
| ProviderName | varchar(80) | ProviderName |
| SpecialtyID | int | Specialty reference key |
| OrganizationID | int | Organization reference key |
| RegionID | int | State reference key, not a sales region |
| RegistrationDate | date | Registration date, UTC calendar |

## ProviderSessions

| Field | Staging type | Meaning |
|---|---|---|
| SessionID | int | Session reference key |
| ProviderID | int | Synthetic provider business key |
| SessionStart | datetime2 | SessionStart |
| DurationMinutes | int | DurationMinutes |

## ProviderEngagement

| Field | Staging type | Meaning |
|---|---|---|
| EngagementID | int | Engagement reference key |
| ProviderID | int | Synthetic provider business key |
| EngagementTypeID | int | EngagementType reference key |
| EngagementTimestamp | datetime2 | Event timestamp in UTC |

## Reporting grains

ProviderMonth: one registered provider per calendar month, including inactive months; attributes are static throughout history. Flags are 0/1. Engagements and PriorEngagements are monthly qualifying counts.

EngagementDetail: one valid unique event; includes nonqualifying profile views.

DataQualityExceptions: one source row per failed rule. DataQualitySummary: one row per checked source table; distinct rejected records are separate from rule failures.
