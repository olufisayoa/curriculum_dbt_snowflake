
  
    

create or replace transient table CURRICULUM_DB.core.dim_badge
    
    
    
    as (SELECT 
md5(cast(coalesce(cast(BV.BadgeValueID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "BadgeValueKey",
B.BadgeName AS "BadgeName",
BV.BadgeValueName AS "BadgeValueName",
BV.BadgeCode AS "BadgeCode",
CAST(BV.IsObsolete AS BOOLEAN) AS "IsObsolete"
FROM CURRICULUM_DB.stg.stg_promonitor__learnerinformation_badgevalue BV
JOIN CURRICULUM_DB.stg.stg_promonitor__learnerinformation_badge B ON BV.BadgeID = B.BadgeID
    )
;


  