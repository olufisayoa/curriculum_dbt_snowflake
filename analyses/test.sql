with og as (
    select distinct trim(AcademicYearID) y, trim(StudentRef) s, trim(CourseCode) c,
           trim(LearningAimRef) a, cast(StartDate as date) d
    from {{ ref('stg_onegrade__estactva') }}
    where CompletionID in (1, 2)
),
pm as (
    select distinct trim(po.AcademicYearID) y, trim(ps.RefNo) s, trim(po.Code) c,
           trim(po.QualID) a, cast(pe.StartDate as date) d
    from {{ ref('stg_prosolution__enrolment') }} pe
    join {{ ref('stg_prosolution__offering') }} po on pe.OfferingID = po.OfferingID
    join {{ ref('stg_prosolution__student') }} ps on pe.StudentDetailID = ps.StudentDetailID
),
pm_any_date   as (select distinct y, s, c, a from pm),
pm_any_aim    as (select distinct y, s, c, d from pm),
pm_any_course as (select distinct y, s, a, d from pm),
pm_students   as (select distinct y, s from pm),
unmatched as (
    select og.* from og
    left join pm on og.y = pm.y and og.s = pm.s and og.c = pm.c and og.a = pm.a and og.d = pm.d
    where pm.y is null
)
select u.s as student, u.c as course, u.d as start_date,
       u.a as onegrade_aim, pm.a as prosolution_aim
from unmatched u
join pm on u.y = pm.y and u.s = pm.s and u.c = pm.c and u.d = pm.d
where u.y = '26/27'