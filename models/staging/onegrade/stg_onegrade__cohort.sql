
WITH cohort AS (
SELECT 
{{ dbt_utils.generate_surrogate_key(['CohortName']) }} AS "CohortKey",
CohortName AS "CohortName"
FROM {{ source('Onegrade', 'ONEGRADE_COHORTLOOKUP') }}
)

SELECT * FROM cohort