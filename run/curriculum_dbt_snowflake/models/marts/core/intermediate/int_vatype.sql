
  
    

create or replace transient table CURRICULUM_DB.int.int_vatype
    
    
    
    as (select distinct VA_Type
from CURRICULUM_DB.stg.stg_onegrade__estactva
    )
;


  