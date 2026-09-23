
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    "ActionPlanKey" as unique_field,
    count(*) as n_records

from CURRICULUM_DB.core.fct_learner_comments
where "ActionPlanKey" is not null
group by "ActionPlanKey"
having count(*) > 1



  
  
      
    ) dbt_internal_test