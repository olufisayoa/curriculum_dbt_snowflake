
    
    

with child as (
    select "CourseKey" as from_field
    from CURRICULUM_DB.core.fct_studentprogress
    where "CourseKey" is not null
),

parent as (
    select "CourseKey" as to_field
    from CURRICULUM_DB.core.dim_course
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


