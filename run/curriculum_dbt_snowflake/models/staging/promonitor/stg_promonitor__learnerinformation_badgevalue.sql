
  create or replace   view CURRICULUM_DB.stg.stg_promonitor__learnerinformation_badgevalue
  
  
  
  
  as (
    SELECT 
BV.BadgeValueID,
BV.BadgeID,
BV.Name AS BadgeValueName,
BV.BadgeCode,
BV.IsObsolete
FROM CURRICULUM_DB.RAW.PROMONITOR_LEARNERINFORMATION_BADGEVALUE BV
  );

