SELECT
MarkTypeID,
RegisterSessionID, 
RegisterStudentID
FROM {{ source('ProSolution', 'PROSOLUTION_MARKTYPE') }}