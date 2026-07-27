
  
    

create or replace transient table CURRICULUM_DB.core.dim_monitoringpoint
    
    
    
    as (SELECT 
*
FROM CURRICULUM_DB.stg.stg_manual__monitoringpoint
    )
;


  