SELECT
"MarkTypeID",
"MarkTypeStatusID",
"IsAuthorisedAbsense",
"IsLate"
FROM {{ source('ProSolution', 'PROSOLUTION_MARKTYPE') }}