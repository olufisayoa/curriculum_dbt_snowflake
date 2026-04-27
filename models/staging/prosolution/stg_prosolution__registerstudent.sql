SELECT
"RegisterStudentID" AS RegisterStudentID,
"EnrolmentID" AS EnrolmentID,
"RegisterID" AS RegisterID
FROM {{ source('ProSolution', 'PROSOLUTION_REGISTERSTUDENT') }}