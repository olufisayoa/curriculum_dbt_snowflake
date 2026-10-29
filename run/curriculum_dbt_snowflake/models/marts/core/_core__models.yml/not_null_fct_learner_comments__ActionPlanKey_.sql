
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select "ActionPlanKey"
from CURRICULUM_DB.core.fct_learner_comments
where "ActionPlanKey" is null



  
  
      
    ) dbt_internal_test