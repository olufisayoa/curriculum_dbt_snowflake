
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select CompletionStatusID
from CURRICULUM_DB.RAW.PROSOLUTION_ENROLMENT
where CompletionStatusID is null



  
  
      
    ) dbt_internal_test