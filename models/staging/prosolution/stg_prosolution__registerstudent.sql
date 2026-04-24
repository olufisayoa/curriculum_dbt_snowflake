SELECT
    RegisterStudentID,
    EnrolmentID
    
FROM {{ source('ProSolution', 'PROSOLUTION_REGISTERSTUDENT') }}