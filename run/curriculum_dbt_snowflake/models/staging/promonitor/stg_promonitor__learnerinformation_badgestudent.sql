
  create or replace   view CURRICULUM_DB.stg.stg_promonitor__learnerinformation_badgestudent
  
  
  
  
  as (
    SELECT
BS.PMStudentID,
BS.BadgeValueID,
BS.BadgeID,
BS.AuditDateCreated
FROM CURRICULUM_DB.RAW.PROMONITOR_LEARNERINFORMATION_BADGESTUDENT BS
  );

