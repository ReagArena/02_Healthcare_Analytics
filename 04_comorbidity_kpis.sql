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