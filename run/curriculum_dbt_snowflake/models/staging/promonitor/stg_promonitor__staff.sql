
  create or replace   view CURRICULUM_DB.stg.stg_promonitor__staff
  
  
  
  
  as (
    SELECT 
S.StaffID,
S.StaffName
FROM CURRICULUM_DB.RAW.PROMONITOR_VSTAFF S
  );

