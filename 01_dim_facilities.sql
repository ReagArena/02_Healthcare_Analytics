CREATE OR REPLACE VIEW `healthcare_analytics.dim_facilities` AS
SELECT DISTINCT
  facid AS facility_id,
  CASE 
    WHEN facid = 'A' THEN 'Metropolitan General Hospital'
    WHEN facid = 'B' THEN 'St. Jude Regional Medical Center'
    WHEN facid = 'C' THEN 'Valley Health Community Hospital'
    WHEN facid = 'D' THEN 'University Teaching Hospital'
    WHEN facid = 'E' THEN 'Central Childrens & Family Hospital'
    ELSE CONCAT('Facility ', CAST(facid AS STRING))
  END AS facility_name
FROM `healthcare_analytics.inpatient_admissions`;