
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__offering
  
  
  
  
  as (
    SELECT 
o.* 
FROM CURRICULUM_DB.RAW.PROSOLUTION_OFFERING AS o
  );

