WITH date_spine AS (
    SELECT
        d.date_day,
        ac.academic_year,
        ac.ay_start_date,
        ac.ay_end_date
    FROM CURRICULUM_DB.stg.stg_manual__date_spine d
    CROSS JOIN CURRICULUM_DB.stg.stg_manual__academic_calendar ac
    WHERE d.date_day BETWEEN ac.ay_start_date AND ac.ay_end_date
),

with_term AS (
    SELECT
        ds.date_day,
        YEAR(ds.date_day) AS calendar_year,
        MONTH(ds.date_day) AS calendar_month,
        DAY(ds.date_day) AS calendar_day,
        ds.academic_year,
        CASE
            WHEN ds.date_day BETWEEN ac.term_1_start AND ac.term_1_end THEN 'Term 1'
            WHEN ds.date_day BETWEEN ac.term_2_start AND ac.term_2_end THEN 'Term 2'
            WHEN ds.date_day BETWEEN ac.term_3_start AND ac.term_3_end THEN 'Term 3'
            ELSE 'Break'
        END AS term,
        CASE
            WHEN ds.date_day BETWEEN ac.term_1_start AND ac.term_3_end
            THEN DATEDIFF(week, ac.term_1_start, ds.date_day) + 1
            ELSE NULL
        END AS week_number,
        awl.week_number AS teaching_week_number
    FROM date_spine ds
    LEFT JOIN CURRICULUM_DB.stg.stg_manual__academic_calendar ac
        ON ds.academic_year = ac.academic_year
    LEFT JOIN CURRICULUM_DB.stg.stg_manual__academic_week_lookup awl
        ON ds.academic_year = awl.academic_year
        AND ds.date_day BETWEEN awl.week_start_date AND awl.week_end_date
)

SELECT
   CAST(TO_CHAR(date_day, 'yyyyMMdd') AS INTEGER) AS "DateKey",
    date_day AS "Date",
    calendar_year AS "CalendarYear",
    calendar_month AS "CalendarMonth",
    calendar_day AS "CalendarDay",
    academic_year AS "AcademicYear",
    term AS "Term",
    week_number AS "WeekNumber",
    COALESCE(teaching_week_number, 99) AS "TeachingWeekSort",
    
    CASE
        WHEN teaching_week_number IS NULL THEN 'Week'
        WHEN term = 'Break' THEN 'Week'
        ELSE 'Week ' || teaching_week_number
    END AS "TeachingWeek"
FROM with_term
ORDER BY date_day