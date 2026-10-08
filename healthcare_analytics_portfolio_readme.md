# Hospital Operational Performance & Patient Flow Analytics

## Executive Summary

This end-to-end healthcare data analytics project evaluates operational performance, inpatient bed utilization, and clinical readmission patterns across **100,000 patient encounters** across 5 regional medical facilities.

Using **Google Cloud BigQuery** for dimensional data modeling (Star Schema) and **Power BI** for advanced visual analytics and DAX modeling, this project identifies critical drivers behind extended hospital stays (ALOS) and high 30–180 day readmission rates.

## Technical Stack & Tools

* **Data Warehouse & ETL:** Google Cloud BigQuery (SQL, DDL View Creation, Analytical Aggregations)

* **Data Modeling & Visualization:** Power BI Desktop (DAX, Star Schema Modeling, Dynamic Slicers)

* **Dataset Scope:** 100,000 records derived from Microsoft Healthcare Length of Stay dataset

* **Key Metrics:** Total Admissions, Average Length of Stay (ALOS), Readmission Rate (%)

## Data Architecture & Dimensional Schema

To optimize query performance and enable scalable BI reporting, raw inpatient data was transformed into a relational **Star Schema** within BigQuery comprising two dimension tables and one central fact table.

```
                  +-----------------------------------+
                  |          dim_facilities           |
                  +-----------------------------------+
                  | PK: facility_id                   |
                  |     facility_name                 |
                  +-----------------------------------+
                                    |
                                    | (1:N)
                                    v
+----------------------------------+ +----------------------------------+
|          dim_patients            | |         fact_admissions          |
+----------------------------------+ |----------------------------------|
| PK: patient_id                   | | PK: encounter_id                 |
|     gender                       | | FK: patient_id                   |
|     dialysisrenal, asthma, etc.  | | FK: facility_id                  |
+----------------------------------+ |     visit_date                   |
                  |                  |     length_of_stay_days          |
                  | (1:N)            |     readmission_count            |
                  +----------------->|     los_category                 |
                                     +----------------------------------+

```

## Core Analytics & SQL Queries

### Comorbidity Burden vs. Clinical Performance Aggregation

```
SELECT 
  (p.dialysisrenal + p.asthma + p.irondef + p.pneum + p.substance + p.hepmode + p.psych) AS comorbidity_count,
  COUNT(a.encounter_id) AS total_admissions,
  ROUND(AVG(a.length_of_stay_days), 2) AS avg_los_days,
  ROUND(
    COUNTIF(SAFE_CAST(a.readmission_count AS INT64) > 0) * 100.0 / COUNT(a.encounter_id), 
    2
  ) AS readmission_rate_pct
FROM `healthcare_analytics.fact_admissions` a
INNER JOIN `healthcare_analytics.dim_patients` p 
  ON a.patient_id = p.patient_id
GROUP BY comorbidity_count
ORDER BY comorbidity_count ASC;

```

## Power BI Measures (DAX)

```
Total Admissions = COUNTROWS('processed_healthcare_data')

Avg Length of Stay = AVERAGE('processed_healthcare_data'[length_of_stay_days])

Readmission Rate % = 
DIVIDE(
    CALCULATE(COUNTROWS('processed_healthcare_data'), 'processed_healthcare_data'[readmission_count] > 0),
    [Total Admissions],
    0
)

```

## Key Clinical & Operational Insights

| Comorbidity Count | Total Admissions | Average Length of Stay (Days) | Readmission Rate (%) | 
| ----- | ----- | ----- | ----- | 
| **0 Conditions** | 72,806 | 3.51 | 40.07% | 
| **1 Condition** | 18,334 | 5.06 | 39.88% | 
| **2 Conditions** | 6,018 | 5.49 | 39.28% | 

1. **Comorbidity Directly Drives Bed Utilization:** Patients with no comorbidities average **3.51 days** in care. Adding just **1 chronic condition** increases average length of stay to **5.06 days**—a **44.2% spike** in hospital resource consumption per stay.

2. **Systemic Readmission Risk Across Population:** Readmission rates remain uniformly high (**\~39.8%**) regardless of recorded comorbidity score. This indicates that readmission risk is primarily driven by post-discharge transitions and discharge communication gaps rather than chronic illness count alone.

## Strategic Recommendations for Healthcare Leadership

1. **Targeted Discharge Protocols:** Establish specialized nurse follow-up calls within 48 hours post-discharge for high-stay patients (>5 days) to mitigate the \~40% readmission baseline.

2. **Resource Allocation for Multi-Comorbidity Units:** Assign dedicated case managers to inpatient wards where average patient comorbidity scores exceed 1.0 to streamline care plans and reduce bed bottlenecking.

3. **Standardized Post-Discharge Care Transitions:** Address systemic readmission rates by implementing standardized discharge medication reconciliation processes across all 5 hospital facilities.

## Repository Structure

```
02_Healthcare_Analytics/
├── README.md                              <-- Project documentation
├── data/
│   └── processed_healthcare_data.csv      <-- Analytical extract
├── sql/
│   ├── 01_dim_facilities.sql
│   ├── 02_dim_patients.sql
│   ├── 03_fact_admissions.sql
│   └── 04_comorbidity_kpis.sql
└── power_bi/
    └── Healthcare_Operational_Dashboard.pbix

```