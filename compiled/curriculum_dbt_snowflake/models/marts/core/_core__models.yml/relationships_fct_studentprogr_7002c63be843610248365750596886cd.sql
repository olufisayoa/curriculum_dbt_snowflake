
    
    

with child as (
    select "EnrolmentKey" as from_field
    from CURRICULUM_DB.core.fct_studentprogress
    where "EnrolmentKey" is not null
),

parent as (
    select "EnrolmentKey" as to_field
    from CURRICULUM_DB.core.dim_enrolment
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


