
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__studentdetailmainoffering
  
  
  
  
  as (
    SELECT 
    StudentDetailID,
    Name         AS MainOfferingCollegeLevelName,
    OfferingName AS MainOfferingName,
    SiteDescription AS StudentMainSite
FROM CURRICULUM_DB.RAW.PROSOLUTION_VSTUDENTDETAILMAINOFFERING
  );

