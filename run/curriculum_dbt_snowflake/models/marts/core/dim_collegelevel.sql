
  
    

create or replace transient table CURRICULUM_DB.core.dim_collegelevel
    
    
    
    as (SELECT * 
FROM CURRICULUM_DB.stg.stg_prosolution__collegelevel
    )
;


  