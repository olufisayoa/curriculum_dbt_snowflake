
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__registermark
  
  
  
  
  as (
    SELECT
"RegisterMarkID" AS RegisterMarkID,
"RegisterSessionID" AS RegisterSessionID,
"RegisterStudentID" AS RegisterStudentID,
"MarkTypeID" AS MarkTypeID,
"CreatedDate" AS CreatedDate 
FROM CURRICULUM_DB.RAW.PROSOLUTION_REGISTERMARK
  );

