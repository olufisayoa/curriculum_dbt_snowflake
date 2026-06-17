SELECT
    academic_year,
    week_start_date,
    DATEADD(day, 6, week_start_date) AS week_end_date,
    week_number
FROM CURRICULUM_DB.int.academic_week_lookup