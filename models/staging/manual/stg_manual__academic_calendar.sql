SELECT
    academic_year,
    term_1_start,
    term_1_end,
    term_2_start,
    term_2_end,
    term_3_start,
    term_3_end,
    LEAST(term_1_start, term_2_start, term_3_start) AS ay_start_date,
    GREATEST(term_1_end, term_2_end, term_3_end) AS ay_end_date
FROM {{ ref('academic_calendar_lookup') }}