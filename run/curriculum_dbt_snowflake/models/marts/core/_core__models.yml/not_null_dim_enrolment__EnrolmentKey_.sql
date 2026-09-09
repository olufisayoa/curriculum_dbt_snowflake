
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select "EnrolmentKey"
from CURRICULUM_DB.core.dim_enrolment
where "EnrolmentKey" is null



  
  
      
    ) dbt_internal_test