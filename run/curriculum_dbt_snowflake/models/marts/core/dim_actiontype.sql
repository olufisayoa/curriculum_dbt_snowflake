
  
    

create or replace transient table CURRICULUM_DB.core.dim_actiontype
    
    
    
    as (SELECT 
md5(cast(coalesce(cast(ActionType.ActionTypeID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "ActionTypeKey",
ActionType.ActionTypeDescription AS "ActionTypeDescription",
ActionType.ActionTypeOrderBy AS "ActionTypeOrderBy",
CAST(ActionType.IsObsolete AS BOOLEAN) AS "IsObsolete"
FROM CURRICULUM_DB.stg.stg_promonitor__learnerinformation_actionplan_actiontype ActionType
    )
;


  