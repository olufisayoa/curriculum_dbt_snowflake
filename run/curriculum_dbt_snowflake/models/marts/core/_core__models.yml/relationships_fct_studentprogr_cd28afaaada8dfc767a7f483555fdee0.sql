
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select "StudentKey" as from_field
    from CURRICULUM_DB.core.fct_studentprogress
    where "StudentKey" is not null
),

parent as (
    select "StudentKey" as to_field
    from CURRICULUM_DB.core.dim_student
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test