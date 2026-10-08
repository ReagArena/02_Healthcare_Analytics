CREATE OR REPLACE VIEW `healthcare_analytics.dim_patients` AS
SELECT DISTINCT
  CAST(eid AS STRING) AS patient_id,
  gender,
  dialysisrenal,
  asthma,
  irondef,
  pneum,
  substance,
  hepmode,
  psych
FROM `healthcare_analytics.inpatient_admissions`;



