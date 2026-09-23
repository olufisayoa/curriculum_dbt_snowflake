
  
    

create or replace transient table CURRICULUM_DB.core.fct_register_compliance
    
    
    
    as (SELECT *
FROM CURRICULUM_DB.int.int_register_compliance
    )
;


  