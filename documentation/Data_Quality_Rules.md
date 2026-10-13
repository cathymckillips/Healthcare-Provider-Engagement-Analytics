# Data quality rules

| ID | Table | Rule |
|---|---|---|
| DQ01 | ProviderEngagement | Missing or malformed provider ID |
| DQ02 | ProviderEngagement | Unknown provider ID |
| DQ03 | ProviderEngagement | Event after reporting cutoff |
| DQ04 | ProviderEngagement | Invalid engagement type |
| DQ05 | ProviderEngagement | Event before registration |
| DQ06 | Providers | Missing or duplicate provider key |
| DQ07 | Providers | Invalid specialty |
| DQ08 | ProviderSessions | Missing or negative session duration |
| DQ09 | ProviderEngagement | Missing or malformed event timestamp |
| DQ10 | Providers | Invalid organization |
| DQ11 | ProviderEngagement | Missing event key or later duplicate event |
| DQ12 | Providers | Invalid state reference |
| DQ13 | Providers | Registration outside coverage or missing |
| DQ14 | ProviderSessions | Unknown session provider |
| DQ15 | ProviderSessions | Invalid session timestamp |
| DQ16 | ProviderSessions | Missing session key or later duplicate |
| DQ17 | ProviderEngagement | Event before coverage |

All flagged transactional/provider rows are excluded, except the earliest duplicate engagement/session copy is retained. Provider duplicate keys reject all copies. Never overwrite raw records to hide exceptions. Investigate in staging, document a corrected source version, then rerun and reconcile. Reference files are controlled synthetic inputs; duplicate/reference maintenance needs additional controls for real production use.

Seeded issues: six event records (DQ01, DQ02, DQ03, DQ04, DQ09, DQ11) and two sessions (DQ08, DQ14). Other rules are implemented but have no baseline exceptions. No historical DQ trend is fabricated: this kit represents one validation snapshot.

Pass rate = SUM(PassedRecords)/SUM(TotalRecords) over Providers, ProviderEngagement, ProviderSessions only. SourceRowID is scoped to SourceTable. Counts of failed rules can exceed rejected record counts.
