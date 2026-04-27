SELECT
"MarkTypeID" AS MarkTypeID,
"MarkTypeStatusID" AS MarkTypeStatusID,
"IsAuthorisedAbsence" AS IsAuthorisedAbsence,
"IsLate" AS IsLate
FROM {{ source('ProSolution', 'PROSOLUTION_MARKTYPE') }}