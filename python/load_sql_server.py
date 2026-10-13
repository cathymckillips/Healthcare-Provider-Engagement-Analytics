"""pip install pyodbc; install Microsoft ODBC Driver 18; edit --server as needed."""
import argparse,csv
from pathlib import Path
import pyodbc
p=argparse.ArgumentParser();p.add_argument('--server',required=True);p.add_argument('--reload',action='store_true');a=p.parse_args()
R=Path(__file__).resolve().parents[1]
c=pyodbc.connect(f'DRIVER={{ODBC Driver 18 for SQL Server}};SERVER={a.server};DATABASE=HealthcareProviderEngagement;Trusted_Connection=yes;Encrypt=yes;TrustServerCertificate=yes',autocommit=False)
try:
 cur=c.cursor()
 tables=['Regions','Specialties','Organizations','EngagementTypes','Providers','ProviderSessions','ProviderEngagement']
 for t in tables:
  n=cur.execute(f'SELECT COUNT(*) FROM raw.{t}').fetchval()
  if n and not a.reload: raise RuntimeError('Raw tables are populated. Stop; use --reload only to deliberately replace this synthetic project data.')
 for t in tables:
  if a.reload: cur.execute(f'DELETE FROM raw.{t}');cur.execute(f'DBCC CHECKIDENT (\'raw.{t}\', RESEED, 0)')
  with (R/'data/synthetic'/f'{t}.csv').open(newline='',encoding='utf-8') as f:
   reader=csv.reader(f);cols=next(reader);rows=[tuple(v or None for v in row) for row in reader]
  cur.fast_executemany=True
  cur.executemany(f'INSERT INTO raw.{t} ({",".join(cols)}) VALUES ({",".join("?" for _ in cols)})',rows)
  print(t,len(rows))
 c.commit()
except Exception:
 c.rollback();raise
finally:c.close()
