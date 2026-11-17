
  
    

create or replace transient table CURRICULUM_DB.core.dim_learningaim
    
    
    
    as (select * from CURRICULUM_DB.int.int_consolidated_learning_aims
    )
;


  