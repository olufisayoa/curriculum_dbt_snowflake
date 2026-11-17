
  create or replace   view CURRICULUM_DB.stg.stg_manual__academic_calendar
  
  
  
  
  as (
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
FROM CURRICULUM_DB.int.academic_calendar_lookup
  );

