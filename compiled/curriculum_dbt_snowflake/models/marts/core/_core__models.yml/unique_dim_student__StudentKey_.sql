
    
    

select
    "StudentKey" as unique_field,
    count(*) as n_records

from CURRICULUM_DB.core.dim_student
where "StudentKey" is not null
group by "StudentKey"
having count(*) > 1


