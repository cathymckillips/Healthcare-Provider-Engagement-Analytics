# Interview talking points

Use completed-work wording only after executing and building the relevant parts.

- I separate raw source data, type conversion, validation, governance, and reporting so discrepancies can be traced to their origin.
- A provider-month spine preserves inactive registered providers; calculating adoption only from event rows would bias the denominator.
- I distinguish monthly active users, cumulative activation, prior-month retention, and registration cohort activity because they answer different questions.
- I keep prior-month activity alongside current month so a date filter does not silently erase retention denominators.
- I retain the original raw values and log rule-level exceptions, while pass rates count distinct rejected records.
- I reconcile monthly Tableau results to SQL counts and record metric definitions before presenting findings.
- This is synthetic portfolio data. Session and event volumes are designed examples, and no causal or real-world company claims follow from them.

Tradeoffs: static attributes, fixed snapshot, CSV refresh, controlled reference tables, view-based processing. Production improvements: incremental persisted layers, reference integrity checks, batch/run IDs, historical provider dimensions, authentication, access controls and automated reconciliation.
