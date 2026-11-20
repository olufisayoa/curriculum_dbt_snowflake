
  create or replace   view CURRICULUM_DB.stg.stg_promonitor__ilp_meetingtype
  
  
  
  
  as (
    SELECT 
MT.MeetingTypeID,
MT.MeetingTypeName,
MT.IsObsolete,
MT.MeetingCategoryID
FROM CURRICULUM_DB.RAW.PROMONITOR_ILP_MEETINGTYPE MT
  );

