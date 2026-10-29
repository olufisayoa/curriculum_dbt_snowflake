
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    RegisterMarkID as unique_field,
    count(*) as n_records

from CURRICULUM_DB.int.int_attendance
where RegisterMarkID is not null
group by RegisterMarkID
having count(*) > 1



  
  
      
    ) dbt_internal_test