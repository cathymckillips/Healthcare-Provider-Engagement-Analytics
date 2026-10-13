# Business requirements

Fictional healthcare engagement platform. Intended audiences: executive leadership (adoption and engagement), customer success (inactive and returning providers), operations (data quality). No affiliation with RxVantage and no proprietary data or company-specific conclusions.

| Requirement | Output | Acceptance |
|---|---|---|
| BR01 consistent executive KPIs | Overview | SQL and Tableau monthly counts match exactly |
| BR02 identify adoption gaps | Adoption | Include registered inactive providers; filter specialty/state |
| BR03 compare specialty/state | Performance | Weighted rates and explicitly defined populations |
| BR04 understand repeat use | Retention | Prior-month denominator preserved; first month N/A |
| BR05 expose reliability | Governance | Eight baseline rejected records; distinct records separated from failures |

Scope: synthetic provider profiles, events, sessions, monthly trends, five dashboards. Excludes patient information, clinical outcomes, revenue attribution, causal claims and live refresh. CSVs are static snapshots. Demonstration stakeholders/owners are proposed roles, not actual interviewed people.

Proposed signoff: BI analyst owns SQL definitions; operations reviews exceptions; business owner approves qualifying event definitions; dashboard owner checks usability. Record changes in Change_Log.md. Snapshot cutoff is fixed for reproducibility.
