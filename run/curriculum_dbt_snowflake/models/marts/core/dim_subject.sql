
  
    

create or replace transient table CURRICULUM_DB.core.dim_subject
    
    
    
    as (select 
    gcse_subject_key::INT AS "SubjectKey",
    gcse_subject_name::VARCHAR(100) AS "GCSE Subject"
from CURRICULUM_DB.stg.stg_manual_gcse_subject
    )
;


  