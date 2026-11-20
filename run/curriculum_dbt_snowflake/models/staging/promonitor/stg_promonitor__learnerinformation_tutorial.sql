
  create or replace   view CURRICULUM_DB.stg.stg_promonitor__learnerinformation_tutorial
  
  
  
  
  as (
    SELECT
Tutorial.TutorialID,
Tutorial.TutorialTypeID
FROM CURRICULUM_DB.RAW.PROMONITOR_LEARNERINFORMATION_TUTORIAL Tutorial
  );

