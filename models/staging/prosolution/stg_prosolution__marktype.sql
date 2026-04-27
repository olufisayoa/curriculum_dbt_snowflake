SELECT
"MarkTypeID",
"MarkTypeStatusID",
"IsAuthorisedAbsence",
"IsLate"
FROM {{ source('ProSolution', 'PROSOLUTION_MARKTYPE') }}