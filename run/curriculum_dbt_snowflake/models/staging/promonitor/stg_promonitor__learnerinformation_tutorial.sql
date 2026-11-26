
  create or replace   view CURRICULUM_DB.stg.stg_promonitor__learnerinformation_tutorial
  
  
  
  
  as (
    SELECT
Tutorial.TutorialID,
Tutorial.TutorialTypeID,
Tutorial.TutorialDate,
Tutorial.CancelledWhen,
Tutorial.DidNotTakePlace,
Tutorial.PMStudentID
FROM CURRICULUM_DB.RAW.PROMONITOR_LEARNERINFORMATION_TUTORIAL Tutorial
  );

