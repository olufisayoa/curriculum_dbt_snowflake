SELECT 
    md5(cast(coalesce(cast(TRIM(_os.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(_os.StudentRef) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS StudentKey,         
    _os.*
FROM CURRICULUM_DB.RAW.ONEGRADE_STUDENT as _os