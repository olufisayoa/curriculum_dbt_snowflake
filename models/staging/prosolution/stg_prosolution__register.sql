SELECT 
"AcademicYearID" AS AcademicYearID,
"RegisterID" AS RegisterID
FROM {{ source('ProSolution', 'PROSOLUTION_REGISTER') }}