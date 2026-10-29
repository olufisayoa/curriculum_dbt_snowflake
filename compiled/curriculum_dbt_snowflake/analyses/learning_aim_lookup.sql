select 'onegrade learningaim' as source, LearningAimRef as aim, count(*) as n
from CURRICULUM_DB.stg.stg_onegrade__learningaim
where LearningAimRef in ('50089766', '50088129')
group by 1, 2
union all
select 'onegrade ofqual', "QualificationNumber", count(*)
from CURRICULUM_DB.stg.stg_onegrade__ofqual
where "QualificationNumber" in ('50089766', '50088129')
group by 1, 2