CREATE OR REPLACE VIEW `healthcare_analytics.fact_admissions` AS
SELECT
  CAST(eid AS STRING) AS encounter_id,
  CAST(eid AS STRING) AS patient_id,
  facid AS facility_id,
  DATE(vdate) AS visit_date,
  lengthofstay AS length_of_stay_days,
  rcount AS readmission_count,
  CASE 
    WHEN lengthofstay <= 2 THEN 'Short Stay (1-2 days)'
    WHEN lengthofstay BETWEEN 3 AND 6 THEN 'Moderate Stay (3-6 days)'
    WHEN lengthofstay BETWEEN 7 AND 10 THEN 'Extended Stay (7-10 days)'
    ELSE 'Critical Prolonged Stay (>10 days)'
  END AS los_category
FROM `healthcare_analytics.inpatient_admissions`;