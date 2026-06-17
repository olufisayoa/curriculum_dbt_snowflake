SELECT 
md5(cast(coalesce(cast(TRIM(AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(CourseCode) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CourseKey,
ID,
AcademicYearID,
CourseCode,
Title
FROM CURRICULUM_DB.RAW.ONEGRADE_COURSE