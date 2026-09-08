
    
    

select
    "EnrolmentKey" as unique_field,
    count(*) as n_records

from CURRICULUM_DB.core.dim_enrolment
where "EnrolmentKey" is not null
group by "EnrolmentKey"
having count(*) > 1


