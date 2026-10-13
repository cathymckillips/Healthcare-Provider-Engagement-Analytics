from pathlib import Path
import csv,random,datetime as dt
R=Path(__file__).resolve().parents[1]
r=random.Random(20261011)
def save(name,headers,rows):
 p=R/'data/synthetic'/f'{name}.csv'; p.parent.mkdir(parents=True,exist_ok=True)
 with p.open('w',newline='',encoding='utf-8') as f:
  w=csv.writer(f); w.writerow(headers); w.writerows(rows)
start=dt.date(2024,1,1); end=dt.date(2026,9,30)
states='AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY'.split()
save('Regions',['RegionID','StateCode'],enumerate(states,1))
specialties=['Family Medicine','Internal Medicine','Pediatrics','Cardiology','Dermatology','Endocrinology','Gastroenterology','Neurology','Oncology','Orthopedics','Psychiatry','Pulmonology','Rheumatology','Urology','Obstetrics Gynecology','Nephrology','Ophthalmology','Otolaryngology','Emergency Medicine','Allergy Immunology']
save('Specialties',['SpecialtyID','SpecialtyName'],enumerate(specialties,1))
save('Organizations',['OrganizationID','OrganizationName'],[(i,f'Synthetic Practice {i:03d}') for i in range(1,301)])
activities=['Resource viewed','Educational content accessed','Product information reviewed','Representative profile viewed','Meeting requested','Meeting completed','Educational event registered','Educational event attended']
save('EngagementTypes',['EngagementTypeID','EngagementTypeName','IsQualifying'],[(i,n,int(i!=4)) for i,n in enumerate(activities,1)])
providers=[]
for i in range(1,5001):
 date=start+dt.timedelta(days=r.randrange(930))
 providers.append([i,f'Synthetic Provider {i:05d}',r.randrange(1,21),r.randrange(1,301),r.randrange(1,51),date.isoformat()])
save('Providers',['ProviderID','ProviderName','SpecialtyID','OrganizationID','RegionID','RegistrationDate'],providers)
sessions=[]
for i in range(1,50001):
 p=r.choice(providers); day=dt.date.fromisoformat(p[-1]); day+=dt.timedelta(days=r.randrange((end-day).days+1))
 stamp=dt.datetime.combine(day,dt.time(r.randrange(24),r.randrange(60)))
 sessions.append([i,p[0],stamp.isoformat(' '),r.randrange(1,91)])
# Isolated bad session copies keep 50,000 valid source sessions intact.
sessions += [[50001,1,'2026-09-15 10:00:00',-5],[50002,99999,'2026-09-15 10:00:00',10]]
save('ProviderSessions',['SessionID','ProviderID','SessionStart','DurationMinutes'],sessions)
events=[]
for i in range(1,100001):
 s=r.choice(sessions[:50000]); events.append([i,s[1],r.choices(range(1,9),[25,20,15,10,10,8,7,5])[0],s[2]])
# Six independent event issues; duplicate copy plus five invalid unique records.
events += [events[0].copy(),[100001,'',1,'2026-09-15 10:00:00'],[100002,99999,1,'2026-09-15 10:00:00'],[100003,1,99,'2026-09-15 10:00:00'],[100004,1,1,'2027-01-01 10:00:00'],[100005,1,1,'']]
save('ProviderEngagement',['EngagementID','ProviderID','EngagementTypeID','EngagementTimestamp'],events)
print('Generated seven source CSVs; seed 20261011')
