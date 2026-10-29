
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__registerstudent
  
  
  
  
  as (
    SELECT
"RegisterStudentID" AS RegisterStudentID,
"EnrolmentID" AS EnrolmentID,
"RegisterID" AS RegisterID
FROM CURRICULUM_DB.RAW.PROSOLUTION_REGISTERSTUDENT
  );

