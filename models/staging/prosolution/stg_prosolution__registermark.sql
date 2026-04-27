SELECT
"RegisterMarkID" AS RegisterMarkID,
"RegisterSessionID" AS RegisterSessionID,
"RegisterStudentID" AS RegisterStudentID,
"MarkTypeID" AS MarkTypeID
FROM {{ source('ProSolution', 'PROSOLUTION_REGISTERMARK') }}