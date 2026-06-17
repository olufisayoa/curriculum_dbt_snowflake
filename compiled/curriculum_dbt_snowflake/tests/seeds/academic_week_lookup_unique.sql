SELECT
    academic_year,
    week_start_date,
    COUNT(*) as duplicate_count
FROM CURRICULUM_DB.stg.stg_manual__academic_week_lookup
GROUP BY
    academic_year,
    week_start_date
HAVING COUNT(*) > 1