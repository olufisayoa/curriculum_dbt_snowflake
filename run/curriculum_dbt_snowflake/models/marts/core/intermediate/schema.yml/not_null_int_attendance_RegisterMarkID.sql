
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select RegisterMarkID
from CURRICULUM_DB.int.int_attendance
where RegisterMarkID is null



  
  
      
    ) dbt_internal_test