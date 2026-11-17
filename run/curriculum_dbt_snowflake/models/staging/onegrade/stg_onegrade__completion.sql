
  create or replace   view CURRICULUM_DB.stg.stg_onegrade__completion
  
  
  
  
  as (
    select * 
from CURRICULUM_DB.RAW.ONEGRADE_COMPLETION
  );

