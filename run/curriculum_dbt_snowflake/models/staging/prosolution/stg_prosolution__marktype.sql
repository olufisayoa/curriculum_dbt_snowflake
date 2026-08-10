
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__marktype
  
  
  
  
  as (
    SELECT
"MarkTypeID" AS MarkTypeID,
"Mark" AS Mark,
"Description" AS MarkTypeDescription,
"MarkTypeStatusID" AS MarkTypeStatusID,
"IsAuthorisedAbsence" AS IsAuthorisedAbsence,
"IsLate" AS IsLate
FROM CURRICULUM_DB.RAW.PROSOLUTION_MARKTYPE
  );

