# Tableau Public build guide

## Connect and protect data grain
1. Open Tableau Public → Connect → Text file → data/tableau_exports/ProviderMonth.csv.
2. Confirm MonthStart, RegistrationDate and RegistrationCohort are Date. ProviderID is a discrete dimension; flags/counts are whole numbers. StateCode is a dimension with Geographic Role → State/Province, country United States.
3. Use this single table for dashboards 1–4. Do not physically join event detail to provider-month; it would multiply monthly flags/counts. Add EngagementDetail, DataQualitySummary and DataQualityExceptions as separate data sources for their sheets.
4. Make MonthStart a single-value filter for KPI sheets; select September 2026. Apply month, specialty and state filters to all appropriate ProviderMonth sheets. Keep trend worksheets on a separate date-range filter. Verify scope under Apply to Worksheets → Selected Worksheets. Activity-type filters apply only to EngagementDetail sheets.

## Create calculated fields in ProviderMonth
Create each with Data pane → right-click → Create Calculated Field.

```tableau
// Activation Rate
IF SUM([RegisteredFlag]) > 0 THEN SUM([ActivatedFlag]) / SUM([RegisteredFlag]) END
```
```tableau
// Engagements per Active Provider
IF SUM([ActiveFlag]) > 0 THEN SUM([Engagements]) / SUM([ActiveFlag]) END
```
```tableau
// Monthly Retention Rate
IF SUM([PriorActiveFlag]) > 0 THEN SUM([RetainedFlag]) / SUM([PriorActiveFlag]) END
```
```tableau
// Engagement Growth Rate
IF SUM([PriorEngagements]) > 0 THEN
(SUM([Engagements])-SUM([PriorEngagements])) / SUM([PriorEngagements]) END
```
```tableau
// Inactive Providers
SUM([RegisteredFlag])-SUM([ActiveFlag])
```
```tableau
// Returning Active Flag (row level)
IF [ActiveFlag]=1 AND [FirstActiveFlag]=0 THEN 1 ELSE 0 END
```
Format rates as Percent, one decimal; counts as whole numbers. Null rates should display N/A through a label or explanatory caption, not zero.

## Dashboard 1 — Executive Overview
1. Create KPI worksheets: drag RegisteredFlag to Text with SUM, title Registered Providers. Duplicate and replace with ActiveFlag (MAU), Activation Rate, Engagements, Monthly Retention Rate. Apply single-month filter to each.
2. Monthly trend: MonthStart continuous Month on Columns, SUM(Engagements) on Rows, Line marks; date range over all months. Do not let the KPI single-month filter collapse this trend.
3. Activity bar (EngagementDetail source): EngagementTypeName on Rows, COUNT(EngagementID) on Columns; filter IsQualifying=1 and EngagementTimestamp to selected month. This source needs its own date/specialty/state filters; label them clearly or create matching parameter-driven filters later.
4. New Dashboard, fixed size 1300 × 850. Use tiled horizontal/vertical containers: title, KPI row, trend and activity charts, filters. Caption: synthetic data, UTC, reporting through September 2026.

## Dashboard 2 — Provider Adoption & Utilization
1. KPI sheets: activation, inactive count, new registrations (SUM(NewRegistrationFlag)). Single month.
2. Activation trend: MonthStart on Columns, Activation Rate on Rows, Line marks; all months.
3. Specialty adoption: SpecialtyName on Rows, Activation Rate on Columns, Bar marks; sort descending, single month.
4. Frequency: create row calculation `IF [Engagements]=0 THEN '0' ELSEIF [Engagements]<=2 THEN '1–2' ELSEIF [Engagements]<=5 THEN '3–5' ELSE '6+' END`; put it on Columns and COUNTD(ProviderID) on Rows, single month. Includes inactive population.
5. Registration trend: MonthStart versus SUM(NewRegistrationFlag). Assemble tiled layout as above.

## Dashboard 3 — Specialty & Regional Performance
1. Specialty chart: SpecialtyName Rows, SUM(Engagements) Columns; single month, descending sort.
2. State map: double-click StateCode, select filled map or circle marks, SUM(ActiveFlag) on Color/Size. Edit Locations if needed, set Country/Region United States.
3. State activation: StateCode Rows, Activation Rate Columns. Include registered denominator in tooltip.
4. Ranking table: SpecialtyName plus SUM(RegisteredFlag), SUM(ActiveFlag), Activation Rate and Engagements per Active Provider, using Measure Names/Measure Values. Do not infer performance solely from volume.
5. Add a map filter action Dashboard → Actions → Filter targeting other ProviderMonth sheets; clearing selection shows all values.

## Dashboard 4 — Retention & Trends
1. MonthStart versus Monthly Retention Rate, line; January 2024 remains null.
2. MonthStart versus Engagement Growth Rate; format percent, negative values visible.
3. New versus returning: MonthStart Columns, Measure Values Rows for SUM(FirstActiveFlag) and SUM(Returning Active Flag), Measure Names Color; stacked bars. Their sum equals MAU.
4. Cohort heatmap: RegistrationCohort Rows, MonthStart Columns (discrete month/year), Square marks, `SUM([ActiveFlag])/SUM([RegisteredFlag])` on Color and optionally Label. Display date headers with years. Title Registration Cohort Activity Rate.
5. Keep trends and cohort month range separate from executive single-month filter. Tooltip explains denominator and UTC cutoff.

## Dashboard 5 — Data Quality & Governance
1. Use DataQualitySummary source. KPI sheets SUM(TotalRecords), SUM(RecordsWithExceptions), and calculated `SUM([PassedRecords])/SUM([TotalRecords])` (DQ Pass Rate).
2. Use DataQualityExceptions source. RuleID Rows, COUNT(SourceRowID) Columns; bar. This is rule failures, not necessarily distinct rejected records.
3. Detail: SourceTable, SourceRowID, RuleID, Issue on Rows; text table. Add SourceTable/RuleID filters. Filters on this source do not change the summary cards unless you deliberately implement matching controls.
4. Add governance text: qualification policy, cutoff, rules, grains, source-to-report lineage and validation status. Do not build a DQ history chart from one snapshot.

## Validate, save, and share
Match September and at least two other months against Expected_Monthly_Totals.csv. Filter a specialty/state and compare a matching SQL GROUP BY query. Verify no duplicated provider-month keys; registered includes inactive; first month retention is N/A. Check all filter scopes and inspect tooltips. Save locally as a packaged workbook (.twbx). Publishing to Tableau Public makes the dashboard and its underlying data publicly accessible; use only supplied synthetic records. Add the published URL and screenshots to README when complete.

Official references checked October 11, 2026:
- https://help.tableau.com/current/pro/desktop/en-gb/examples_text.htm
- https://help.tableau.com/current/pro/desktop/en-us/save_savework.htm
- https://www.tableau.com/blog/local-file-save-tableau-desktop-public-edition
