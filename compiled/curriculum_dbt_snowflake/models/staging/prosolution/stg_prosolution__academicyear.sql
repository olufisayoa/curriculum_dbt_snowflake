SELECT 
md5(cast(coalesce(cast(AcademicYearID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "AcademicYearKey",
AcademicYearID ,
StartDate,
EndDate,
Number
FROM CURRICULUM_DB.RAW.PROSOLUTION_ACADEMICYEAR