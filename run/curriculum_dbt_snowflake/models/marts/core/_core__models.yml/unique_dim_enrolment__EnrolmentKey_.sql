
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    "EnrolmentKey" as unique_field,
    count(*) as n_records

from CURRICULUM_DB.core.dim_enrolment
where "EnrolmentKey" is not null
group by "EnrolmentKey"
having count(*) > 1



  
  
      
    ) dbt_internal_test