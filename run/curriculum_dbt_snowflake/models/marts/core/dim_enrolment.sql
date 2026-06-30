
  
    

create or replace transient table CURRICULUM_DB.core.dim_enrolment
    
    
    
    as (select * from CURRICULUM_DB.int.int_consolidated_enrolments
    )
;


  