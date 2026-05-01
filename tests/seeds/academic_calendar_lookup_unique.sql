SELECT
    academic_year,
    COUNT(*) as duplicate_count
FROM {{ ref('stg_manual__academic_calendar') }}
GROUP BY
    academic_year
HAVING COUNT(*) > 1