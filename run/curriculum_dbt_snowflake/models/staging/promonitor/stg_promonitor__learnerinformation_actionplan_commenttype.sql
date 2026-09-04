
  create or replace   view CURRICULUM_DB.stg.stg_promonitor__learnerinformation_actionplan_commenttype
  
  
  
  
  as (
    SELECT 
CT.CommentTypeID,
CT.Title AS CommentTypeName,
CT.IsObsolete
FROM CURRICULUM_DB.RAW.PROMONITOR_LEARNERINFORMATION_ACTIONPLAN_COMMENTTYPE CT
  );

