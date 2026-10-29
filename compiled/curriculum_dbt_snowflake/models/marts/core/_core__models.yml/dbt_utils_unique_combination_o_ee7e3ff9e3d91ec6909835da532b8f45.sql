





with validation_errors as (

    select
        "EnrolmentKey", "MPKey"
    from CURRICULUM_DB.core.fct_studentprogress
    group by "EnrolmentKey", "MPKey"
    having count(*) > 1

)

select *
from validation_errors


