
  create or replace   view CURRICULUM_DB.stg.stg_promonitor__learnerinformation_badge
  
  
  
  
  as (
    SELECT
B.BadgeID,
B.NAME AS BadgeName
FROM CURRICULUM_DB.RAW.PROMONITOR_LEARNERINFORMATION_BADGE B
  );

