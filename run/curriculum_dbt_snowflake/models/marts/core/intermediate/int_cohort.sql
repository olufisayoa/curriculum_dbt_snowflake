
  
    

create or replace transient table CURRICULUM_DB.int.int_cohort
    
    
    
    as (select distinct Cohort
from CURRICULUM_DB.stg.stg_onegrade__estactva
    )
;


  