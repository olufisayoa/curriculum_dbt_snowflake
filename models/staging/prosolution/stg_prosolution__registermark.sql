SELECT
RegisterMarkID,
RegisterSessionID, 
RegisterStudentID,
MarkTypeID,
StartTime,
EndTime,
Duration,
MinsLate
FROM {{ source('ProSolution', 'PROSOLUTION_REGISTERMARK') }}