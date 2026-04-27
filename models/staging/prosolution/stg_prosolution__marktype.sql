SELECT
"MarkTypeID" AS MarkTypeID,
"Mark" AS Mark,
"Description" AS MarkTypeDescription,
"MarkTypeStatusID" AS MarkTypeStatusID,
"IsAuthorisedAbsence" AS IsAuthorisedAbsence,
"IsLate" AS IsLate
FROM {{ source('ProSolution', 'PROSOLUTION_MARKTYPE') }}