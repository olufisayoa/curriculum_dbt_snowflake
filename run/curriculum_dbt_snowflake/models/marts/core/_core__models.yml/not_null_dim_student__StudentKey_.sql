
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select "StudentKey"
from CURRICULUM_DB.core.dim_student
where "StudentKey" is null



  
  
      
    ) dbt_internal_test