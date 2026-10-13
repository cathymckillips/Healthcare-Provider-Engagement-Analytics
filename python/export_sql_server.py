import argparse,csv
from pathlib import Path
import pyodbc
p=argparse.ArgumentParser();p.add_argument('--server',required=True);a=p.parse_args()
R=Path(__file__).resolve().parents[1]
c=pyodbc.connect(f'DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={a.server};DATABASE=HealthcareProviderEngagement;Trusted_Connection=yes;Encrypt=yes;TrustServerCertificate=yes')
for view in ['ProviderMonth','EngagementDetail','DataQualityExceptions','DataQualitySummary']:
 cur=c.cursor().execute(f'SELECT * FROM reporting.vw_{view}')
 with (R/'data/tableau_exports'/f'{view}.csv').open('w',newline='',encoding='utf-8') as f:
  w=csv.writer(f);w.writerow([x[0] for x in cur.description]);w.writerows(cur)
 print(view,'exported')
c.close()
