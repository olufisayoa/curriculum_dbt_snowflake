
  create or replace   view CURRICULUM_DB.stg.stg_promonitor__learnerinformation_actionplan
  
  
  
  
  as (
    SELECT
AP.ActionPlanID,
AP.ActionTypeID,
AP.CommentTypeID,
AP.CommentStaffID,
AP.CommentDate,
AP.PMStudentID,
AP.TutorialID
FROM CURRICULUM_DB.RAW.PROMONITOR_LEARNERINFORMATION_ACTIONPLAN AP
  );

