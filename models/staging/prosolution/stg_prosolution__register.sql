SELECT 
"AcademicYearID" AS AcademicYearID,
"RegisterID" AS RegisterID,
"RegisterNo" AS RegisterNo,
"Title" AS Title,
"SID" AS SID
FROM {{ source('ProSolution', 'PROSOLUTION_REGISTER') }}