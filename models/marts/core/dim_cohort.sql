
SELECT 
         {{ dbt_utils.generate_surrogate_key([
         'TRIM(Cohort)'])}} AS "CohortKey",
         Cohort AS "Cohort"
FROM {{ ref('int_cohort') }}