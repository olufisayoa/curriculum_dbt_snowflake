WITH date_range AS (
    SELECT
        DATEADD(day, seq4(), '2023-01-01'::DATE) AS date_day
    FROM
        TABLE(GENERATOR(rowcount => 10000))  -- Generates ~27 years of dates
    WHERE
        DATEADD(day, seq4(), '2023-01-01'::DATE) <= CURRENT_DATE + INTERVAL '2 years'
)

SELECT
    date_day
FROM date_range
ORDER BY date_day