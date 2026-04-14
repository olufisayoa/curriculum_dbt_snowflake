SELECT 
{{ dbt_utils.generate_surrogate_key(['AcademicYearID']) }} AS "AcademicYearKey",
AcademicYearID ,
StartDate,
EndDate,
Number
FROM {{ source('ProSolution', 'PROSOLUTION_ACADEMICYEAR') }}