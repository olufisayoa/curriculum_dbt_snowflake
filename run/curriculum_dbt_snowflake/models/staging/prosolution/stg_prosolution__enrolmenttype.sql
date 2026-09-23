
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__enrolmenttype
  
  
  
  
  as (
    select 
"EnrolmentTypeID" AS EnrolmentTypeID,
"Description" AS Description
 from CURRICULUM_DB.RAW.PROSOLUTION_ENROLMENTTYPE
  );

