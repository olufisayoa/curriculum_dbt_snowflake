SELECT 
RegisterID,
RegisterNo,
Title,
AcademicYearID,
SID,
StartDate
EndDate
FROM {{ source('ProSolution', 'PROSOLUTION_REGISTER') }}