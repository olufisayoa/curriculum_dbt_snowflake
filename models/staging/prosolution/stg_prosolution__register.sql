SELECT 
"AcademicYearID" AS AcademicYearID,
"RegisterID" AS RegisterID,
"RegisterNo" AS RegisterNo,
"Title" AS Title
FROM {{ source('ProSolution', 'PROSOLUTION_REGISTER') }}