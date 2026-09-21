
  
    

create or replace transient table CURRICULUM_DB.core.dim_student
    
    
    
    as (select * from CURRICULUM_DB.int.int_consolidated_student_detail
    )
;


  