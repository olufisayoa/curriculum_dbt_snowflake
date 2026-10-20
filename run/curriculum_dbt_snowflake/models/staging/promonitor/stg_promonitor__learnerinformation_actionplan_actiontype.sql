
  create or replace   view CURRICULUM_DB.stg.stg_promonitor__learnerinformation_actionplan_actiontype
  
  
  
  
  as (
    SELECT 
ActionType.ID AS ActionTypeID,
ActionType.ActionDescription AS ActionTypeDescription,
ActionType.OrderBy AS ActionTypeOrderBy,
ActionType.IsObsolete AS IsObsolete
FROM CURRICULUM_DB.RAW.PROMONITOR_LEARNERINFORMATION_ACTIONPLAN_ACTIONTYPE ActionType
  );

