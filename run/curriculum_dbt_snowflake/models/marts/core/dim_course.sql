
  
    

create or replace transient table CURRICULUM_DB.core.dim_course
    
    
    
    as (SELECT 
*
FROM CURRICULUM_DB.int.int_consolidated_course_offerings
    )
;


  