
  create or replace   view CURRICULUM_DB.stg.stg_prosolution__examstudent_stats
  
  
  
  
  as (
    SELECT
    StudentID,
    HasSpecialArrangements
FROM CURRICULUM_DB.RAW.PROSOLUTION_VEXAMSTUDENT_STATS
  );

