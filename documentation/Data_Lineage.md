# Data lineage

Seeded Python generator → seven raw CSVs → parameterized SQL loader → raw tables → typed staging views → exception view → governed provider/event/session views → reporting provider-month/event-detail/DQ views → CSV export → Tableau Public worksheets and dashboards.

ProviderMonth uses the provider-month spine, qualifying event counts, first valid engagement, and previous-month counts. Zero activity months survive. EventDetail includes nonqualifying events with a qualification flag. DQSummary measures checked source tables before governance exclusions.

The bundled starter exports are Python reference outputs from the same seed, not evidence of SQL execution. Replace them with SQL-generated exports before claiming an end-to-end SQL implementation. Reconcile against validation/Expected_Monthly_Totals.csv. The fixed snapshot provides no validation run history; omit DQ trend charts until run snapshots exist.
