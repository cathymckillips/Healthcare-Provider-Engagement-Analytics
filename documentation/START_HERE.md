# Start here — step-by-step build

1. Extract the entire ZIP to a short Windows path such as C:\Projects\Healthcare-Provider-Engagement-Analytics. Keep folders together. Markdown documents open in VS Code, a text editor, or GitHub. Data is already generated; Python regeneration is optional.
2. Open SSMS, connect to your SQL Server Developer instance, and run sql/01_database_setup.sql. It safely reuses the database and schemas you already created. Verify raw, staging, governed, reporting in Security → Schemas.
3. Run sql/02_create_raw_tables.sql. Seven raw tables should appear. Do not use Import Flat File to infer types or overwrite these tables.
4. Install Python dependency from a terminal at the project root: `py -m pip install -r python/requirements.txt`. Install Microsoft ODBC Driver 18 if absent. Find your exact server name in SSMS connection properties. Windows integrated authentication is used.
5. Load the included CSVs: `py python/load_sql_server.py --server "localhost"`. Replace localhost with your server/instance. If loading fails, the transaction rolls back. Loading populated tables stops automatically. `--reload` intentionally deletes/replaces only this project's seven raw tables, and should only be used when you want to reload this synthetic kit.
6. Run SQL scripts 03, 04, 05 and 06 in numerical order. Run each complete file in SSMS (GO separates view batches). Script 04 precedes governed views because they depend on the exception view.
7. Run sql/07_reconciliation.sql. Compare every monthly row with validation/Expected_Monthly_Totals.csv and counts with validation/BUILD_VALIDATION.json. Expect 100,006 raw events, 100,000 governed events, 50,002 raw sessions, 50,000 governed sessions, 5,000 providers and eight exception records. All three final difference checks should be zero.
8. Export actual SQL results: `py python/export_sql_server.py --server "localhost"`. This overwrites four bundled reference CSVs with your SQL reporting data. The starter CSVs let you preview Tableau earlier, but do not substitute for validating SQL.
9. Follow Tableau_Build_Guide.md. Start with ProviderMonth.csv and September 2026 only. Build one dashboard and reconcile before expanding.
10. Save your packaged workbook under tableau/HealthcareProviderEngagement.twbx. Take final dashboard screenshots and put them in screenshots/. No workbook or finished screenshots are supplied in this kit; you will create them.
11. Create GitHub repository Healthcare-Provider-Engagement-Analytics. Upload project folders, replace README's status with what you actually completed, and add your Tableau Public link after publication. Publish only synthetic data.

Optional regenerate: `py python/generate_synthetic_data.py` recreates source CSVs with the fixed seed. It does not refresh SQL or Tableau exports; rerun the loader deliberately, SQL checks and exporter afterwards.

Troubleshooting: login errors → verify exact server and Windows account; ODBC driver not found → install Driver 18; schema already exists → use script 01; view not found → run scripts in order; inflated MAU → use one month and avoid physical joins; bad dates → set MonthStart to Date in Tableau; connection file missing → keep exports with workbook or save packaged workbook.
