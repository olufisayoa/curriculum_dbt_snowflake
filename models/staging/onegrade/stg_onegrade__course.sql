SELECT 
{{ dbt_utils.generate_surrogate_key(['TRIM(AcademicYearID)', 'TRIM(CourseCode)']) }} AS CourseKey,
AcademicYearID,
CourseCode,
Title
FROM {{ source('Onegrade', 'ONEGRADE_COURSE') }}