SELECT 
    "RegisterSessionID",
    "RegisterID",
    "SessionNo",
    "Date",
    "StartTime",
    "EndTime",
    "Duration"
FROM {{ source('ProSolution', 'PROSOLUTION_REGISTERSESSION') }}