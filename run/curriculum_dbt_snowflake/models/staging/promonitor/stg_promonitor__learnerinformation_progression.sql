
  create or replace   view CURRICULUM_DB.stg.stg_promonitor__learnerinformation_progression
  
  
  
  
  as (
    SELECT
P.PMStudentID,
P.Information1
FROM CURRICULUM_DB.RAW.PROMONITOR_LEARNERINFORMATION_PROGRESSION AS P
  );

