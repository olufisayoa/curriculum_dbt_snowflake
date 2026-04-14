SELECT 
{{ dbt_utils.generate_surrogate_key(['TRIM(AcademicYearID)', 'TRIM(CourseCode)']) }} AS CourseKey,
ID,
AcademicYearID,
CourseCode,
Title
FROM {{ source('Onegrade', 'ONEGRADE_COURSE') }}