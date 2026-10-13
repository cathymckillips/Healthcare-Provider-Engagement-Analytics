# Healthcare Provider Engagement Analytics

### Executive Engagement Overview | Python • SQL Server • Tableau Public

An end-to-end portfolio project that turns synthetic healthcare provider activity into an executive dashboard for understanding platform adoption, ongoing engagement, and monthly retention.

The completed Tableau deliverable is **one dashboard: Executive Engagement Overview**. It combines five KPI cards with a monthly engagement trend and an activity-type breakdown. The project emphasizes the data definitions, validation, and reconciliation behind those visuals.

**Author:** Catherine McKillips

## Business Scenario

A fictional healthcare technology platform connects providers with educational resources, product information, and industry representatives. Its leadership needs to understand:

- How many providers have registered and how many are currently active?
- What proportion of registered providers have engaged at least once?
- Are providers active in the prior month returning?
- How does engagement change over time?
- Which qualifying activities contribute to engagement volume?

The dashboard provides an overview of these questions using a September 2026 KPI snapshot and historical activity from January 2024 through September 2026.

## Completed Dashboard

| Component | What it shows |
|---|---|
| Registered Providers | Registered provider population as of the selected month end |
| Monthly Active Providers | Providers with at least one qualifying event during the month |
| Qualifying Engagements | Valid qualifying events during the month |
| Provider Activation Rate | Registered providers who have engaged at least once by month end |
| Monthly Retention Rate | Prior-month active providers who return in the current month |
| Monthly Engagement Trend | Qualifying engagement volume across 33 calendar months |
| Engagements by Activity Type | September qualifying events grouped by activity |

The KPI cards and activity chart use **September 2026**. The trend retains the full **January 2024–September 2026** timeline.

<!-- Add your final dashboard screenshot to screenshots/Executive_Overview.png, then uncomment the following line. -->
<!-- ![Executive Engagement Overview](screenshots/Executive_Overview.png) -->
<!-- Add a Tableau Public URL here if you publish the workbook. -->

# Tableau Dashboard

The Tableau dashboard contains **one page**, providing an executive view of healthcare provider adoption, activity, and retention. Built on validated SQL reporting datasets, it combines a monthly KPI snapshot with historical engagement trends.

---

## Page 1 — Executive Engagement Overview

This dashboard brings together registered providers, monthly active providers, qualifying engagements, provider activation rate, and monthly retention rate to show how providers adopt and continue using a fictional healthcare platform.
A monthly engagement trend tracks activity from January 2024 through September 2026, while an activity-type breakdown highlights the qualifying interactions contributing to September engagement.
The dashboard distinguishes cumulative activation from current-month activity and returning-provider retention. KPI totals were reconciled against SQL Server results to verify reporting accuracy.
All data is synthetic and created solely for portfolio demonstration.

![Executive Engagement Overview](images/dashboard.png)

## Technology Stack

| Tool | Role |
|---|---|
| Python | Reproducible synthetic data generation, SQL loading, and CSV exports |
| SQL Server Developer Edition | Raw storage, transformations, data quality checks, and reporting views |
| SQL Server Management Studio | SQL development and reconciliation |
| Tableau Public | Calculated fields, KPI worksheets, charts, and dashboard layout |
| CSV | Transfer of validated SQL reporting results into Tableau |

## Data Pipeline

1. Generate synthetic source records using Python and a fixed random seed.
2. Load seven CSV datasets into the `HealthcareProviderEngagement` database.
3. Convert source text values into typed staging fields.
4. Identify invalid references, timestamps, durations, and duplicate keys.
5. Store validation exceptions in an indexed snapshot and exclude flagged records through governed views.
6. Build reporting datasets, including one row per eligible provider per calendar month.
7. Reconcile reporting counts and monthly totals in SQL.
8. Export reporting CSVs and validate Tableau KPI totals against SQL results.

### Database Layers

| Schema | Purpose |
|---|---|
| `raw` | Preserves original source values, including intentional errors |
| `staging` | Standardizes fields and converts data types using `TRY_CONVERT` |
| `governed` | Provides validated records and stores the exception snapshot |
| `reporting` | Supplies dashboard datasets and validation outputs |

The provider-month dataset includes registered providers with **zero engagement**, preserving the denominator for adoption and activity calculations. Previous-month activity is included alongside current-month metrics so the current-month filter does not remove the retention denominator.

## Synthetic Source Data

| Dataset | Source rows | Purpose |
|---|---:|---|
| Providers | 5,000 | Synthetic provider profiles and registration dates |
| Specialties | 20 | Medical specialty reference values |
| Organizations | 300 | Fictional healthcare organizations |
| Regions | 50 | U.S. state reference values |
| EngagementTypes | 8 | Activity definitions and qualification flags |
| ProviderEngagement | 100,006 | Engagement events, including six intentional exception records |
| ProviderSessions | 50,002 | Session activity, including two intentional exception records |

**Coverage:** January 1, 2024–September 30, 2026. Timestamps are interpreted in UTC. The reporting cutoff is fixed for reproducibility.

## KPI Definitions

| KPI | Calculation |
|---|---|
| Registered Providers | Eligible registered providers as of month end |
| Monthly Active Providers | Providers with at least one valid qualifying engagement during the month |
| Qualifying Engagements | Valid, deduplicated events with `IsQualifying = 1` |
| Provider Activation Rate | Activated providers as of month end ÷ registered providers as of month end |
| Monthly Retention Rate | Providers active in both the prior and current month ÷ prior-month active providers |

**Activation and activity answer different questions.** Activation is cumulative: a provider has engaged at least once. Monthly activity measures engagement during a specific month. A provider can be activated without being active in September.

Representative profile views are excluded from qualifying engagement. Resource views, educational content access, product information reviews, meeting requests/completions, and educational event registrations/attendance qualify. Login sessions do not count as engagement.

Rates return null when their denominator is zero. Monthly provider counts must not be summed across months and presented as distinct providers for the entire period.

### Tableau Calculated Fields

**Provider Activation Rate**

```tableau
IF SUM([RegisteredFlag]) > 0 THEN
    SUM([ActivatedFlag]) / SUM([RegisteredFlag])
END
```

**Monthly Retention Rate**

```tableau
IF SUM([PriorActiveFlag]) > 0 THEN
    SUM([RetainedFlag]) / SUM([PriorActiveFlag])
END
```

Rates are displayed to two decimal places, keeping the September activation rate of 99.98% from rounding to 100%.

## Data Quality and Governance

The SQL validation layer implements 17 rules covering required identifiers, reference integrity, reporting coverage, registration chronology, duplicate keys, required timestamps, and session duration.

Eight intentionally introduced records were identified:

| Rule | Exception | Records |
|---|---|---:|
| DQ01 | Missing engagement provider ID | 1 |
| DQ02 | Unknown engagement provider | 1 |
| DQ03 | Engagement after the reporting cutoff | 1 |
| DQ04 | Invalid engagement type | 1 |
| DQ08 | Negative session duration | 1 |
| DQ09 | Missing engagement timestamp | 1 |
| DQ11 | Later duplicate engagement record | 1 |
| DQ14 | Unknown session provider | 1 |

Raw records remain available for investigation. Governed views exclude flagged records; the earliest duplicate event is retained. Validation results are stored in `governed.DataQualityExceptionSnapshot` to avoid repeatedly evaluating the full exception view during downstream queries.

**Refresh requirement:** Rerun the revised script `05_governed_views.sql` after changing raw data or validation rules, then reconcile and export again. The exception snapshot must reflect the same source data as the reporting outputs.

## Reconciliation Results

SQL checks confirmed:

- **5,000** governed providers.
- **100,000** governed engagement events, including valid nonqualifying events.
- **50,000** governed sessions.
- **91,291** provider-month rows across 33 calendar months.
- Zero difference between provider-month engagement totals and qualifying event-detail counts.
- Zero rows where retained-provider flags exceed prior-month active flags.
- Zero duplicate provider-month keys.

### September 2026 Dashboard Validation

| Metric | Validated result |
|---|---:|
| Registered Providers | 5,000 |
| Monthly Active Providers | 2,231 |
| Qualifying Engagements | 7,603 |
| Activated Providers | 4,999 |
| Provider Activation Rate | 99.98% |
| Prior-Month Active Providers | 2,238 |
| Retained Providers | 1,189 |
| Monthly Retention Rate | 53.13% |

The seven qualifying activity categories reconcile to **7,603** events. The five dashboard KPI cards match the September SQL results.

## Interpretation

In the synthetic September snapshot, nearly all registered providers had engaged at least once, while **44.62%** were active during September. Monthly retention was **53.13%**. These measures illustrate why cumulative activation, current activity, and repeat engagement should be evaluated separately.

These are demonstration results from generated data, not findings about an actual healthcare platform.

## Project Files

| Location | Contents |
|---|---|
| `python/` | Data generator, SQL loader, SQL exporter, and requirements |
| `sql/` | Database setup, raw tables, staging, validation, governance, reporting, and reconciliation scripts |
| `data/synthetic/` | Seven synthetic source CSVs |
| `data/tableau_exports/` | SQL reporting exports for Tableau |
| `documentation/` | Business requirements, KPI definitions, dictionary, validation rules, lineage, and build guidance |
| `validation/` | Expected monthly totals and starter-kit validation baselines |
| `tableau/` | Location for the completed packaged workbook |
| `screenshots/` | Location for the final Executive Overview screenshot |

The original kit contains guidance for additional dashboards. This repository's completed visualization scope is the **Executive Engagement Overview only**; additional dashboard instructions are reference material.

## Reproduce the Project

1. Run SQL scripts `01_database_setup.sql` and `02_create_raw_tables.sql` in SSMS.
2. Install the Python dependency:

   ```bat
   py -m pip install -r python/requirements.txt
   ```

3. Load the included synthetic CSVs, replacing the server placeholder:

   ```bat
   py python/load_sql_server.py --server "YOUR_SERVER_NAME"
   ```

4. Run scripts 03, **revised 04**, **revised 05**, and 06 in order. Use the corrected window-function validation script and exception-snapshot governance script developed for this project, rather than the original starter-kit versions.
5. Run `07_reconciliation.sql` and compare monthly results with `validation/Expected_Monthly_Totals.csv`.
6. Export actual SQL reporting results:

   ```bat
   py python/export_sql_server.py --server "YOUR_SERVER_NAME"
   ```

7. In Tableau Public, connect to `ProviderMonth.csv` and `EngagementDetail.csv` as separate data sources. Avoid a physical join that multiplies provider-month rows by event records.
8. Build the five KPI worksheets and two charts, apply the documented date scopes, reconcile totals, and save the packaged workbook.

Python SQL connections use Windows integrated authentication and Microsoft ODBC Driver 18. The SQL exporter refreshes four CSVs; the completed dashboard uses ProviderMonth and EngagementDetail. The two data quality exports support validation but are not additional completed dashboard pages.

## Skills Demonstrated

- Relational data modeling and layered SQL transformations.
- Reproducible synthetic data generation and parameterized loading.
- Data quality exception detection and governed reporting.
- Consistent KPI definitions and appropriate reporting grains.
- SQL-to-Tableau reconciliation.
- Tableau calculated fields, aggregation, filters, and dashboard composition.
- Documentation of lineage, refresh dependencies, and metric interpretation.

## Data Disclaimer

All data used in this project is synthetic and was created solely for portfolio and demonstration purposes. No real healthcare providers, patients, healthcare organizations, confidential business information, or proprietary company data is included. This independent project is not affiliated with RxVantage or any other healthcare platform. Synthetic results do not support real-world business or clinical conclusions.
