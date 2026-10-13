# KPI definitions and reporting contract

Coverage: 2024-01-01 through 2026-09-30 inclusive; all timestamps UTC. September 2026 is the latest complete month. No partial current month. Eligible provider: governed valid registration before the following month starts. Qualification: all activity types except Representative profile viewed. Login sessions never count as engagement. Valid nonqualifying events remain available in event detail.

| KPI | Definition | Filter behavior |
|---|---|---|
| Registered Providers | Registered eligible population as of selected month end | Single month; SUM(RegisteredFlag) |
| Active Providers / MAU | Distinct eligible providers with >=1 valid qualifying event in month | Single month; SUM(ActiveFlag) |
| Activation Rate | Providers with first qualifying event on/before month end / registered population at month end | Cumulative as of month end; SUM(ActivatedFlag)/SUM(RegisteredFlag) |
| Total Engagements | Valid deduplicated qualifying events in month or selected range | SUM(Engagements) |
| Average Engagements per Active Provider | Monthly qualifying engagements / MAU | Single month ratio |
| Retention Rate | Prior-month active providers also active this month / all prior-month active providers | SUM(RetainedFlag)/SUM(PriorActiveFlag); January 2024 undefined |
| Engagement Growth Rate | (Current qualifying engagements - previous month's)/previous month's | PriorEngagements; undefined if previous count=0 |
| New Registrations | Registrations occurring during month | SUM(NewRegistrationFlag) |

Return NULL, displayed as N/A, for zero denominators. Do not average precomputed percentages. For multi-month active count use COUNTD(IF [ActiveFlag]=1 THEN [ProviderID] END); do not sum monthly MAU as a distinct period total. Cumulative provider cards and activation cards must use one selected month. Retention is monthly return, not cohort survival. A returning active provider is ActiveFlag=1 and FirstActiveFlag=0; this includes reactivated providers, who may not be retained from the prior month.

Cohort matrix: RegistrationCohort on rows, MonthStart on columns; SUM(ActiveFlag)/SUM(RegisteredFlag) within a cohort-month. This is activity participation among that registration cohort, not prior-month retention. No pre-registration cells.

Specialty and state filters use static provider attributes. Regional adoption means activation rate by state; there is no external provider universe, so market penetration cannot be inferred. Geography is 50 states, no DC/territories. Event-type filters affect the event-detail activity chart only; they must not redefine official MAU/retention. Month filter retains prior-month flags because they are precomputed in SQL.
