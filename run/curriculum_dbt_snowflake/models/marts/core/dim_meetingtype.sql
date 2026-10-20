
  
    

create or replace transient table CURRICULUM_DB.core.dim_meetingtype
    
    
    
    as (SELECT 
md5(cast(coalesce(cast(MT.MeetingTypeID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "MeetingTypeKey",
MT.MeetingTypeName AS "MeetingTypeName",
MC.MeetingCategoryName AS "MeetingCategoryName",
CAST(MT.IsObsolete AS BOOLEAN) AS "IsObsolete"
FROM CURRICULUM_DB.stg.stg_promonitor__ilp_meetingtype MT
LEFT JOIN CURRICULUM_DB.stg.stg_promonitor_ilp_meetingcategory MC ON MT.MeetingCategoryID = MC.MeetingCategoryID
    )
;


  