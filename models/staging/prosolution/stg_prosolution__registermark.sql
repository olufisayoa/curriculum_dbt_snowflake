SELECT
"RegisterMarkID" AS RegisterMarkID,
"RegisterSessionID" AS RegisterSessionID,
"RegisterStudentID" AS RegisterStudentID,
"MarkTypeID" AS MarkTypeID,
"CreatedDate" AS CreatedDate 
FROM {{ source('ProSolution', 'PROSOLUTION_REGISTERMARK') }}