SELECT 
AcademicYearID ,
StartDate,
EndDate,
Number
FROM {{ source('ProSolution', 'PROSOLUTION_ACADEMICYEAR') }}