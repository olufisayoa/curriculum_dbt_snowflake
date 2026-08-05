
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__marktypestatus
  
  
  
  
  as (
    SELECT 
"MarkTypeStatusID" AS MarkTypeStatusID,
"Description" AS Description
FROM CURRICULUM_DB.RAW.PROSOLUTION_MARKTYPESTATUS
  );

