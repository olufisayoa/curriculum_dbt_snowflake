
SELECT 
         "CohortKey" AS "CohortKey",
         "CohortName" AS "CohortName"
FROM {{ ref('stg_onegrade__cohort') }}