SELECT 
"RegisterSessionID" AS RegisterSessionID,
"RegisterID" AS RegisterID,
"SessionNo" AS SessionNo,
"Date" AS Date,
"StartTime" AS StartTime,
"EndTime" AS EndTime,
"Duration" AS Duration
FROM {{ source('ProSolution', 'PROSOLUTION_REGISTERSESSION') }}