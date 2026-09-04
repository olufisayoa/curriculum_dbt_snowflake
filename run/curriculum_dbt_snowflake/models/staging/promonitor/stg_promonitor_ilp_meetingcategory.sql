
  create or replace   view CURRICULUM_DB.stg.stg_promonitor_ilp_meetingcategory
  
  
  
  
  as (
    SELECT 
MC.MeetingCategoryID,
MC.MeetingCategoryName
FROM CURRICULUM_DB.RAW.PROMONITOR_ILP_MEETINGCATEGORY MC
  );

