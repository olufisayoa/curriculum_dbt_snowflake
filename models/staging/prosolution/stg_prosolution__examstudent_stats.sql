SELECT
    StudentID,
    HasSpecialArrangements
FROM {{ source('ProSolution', 'PROSOLUTION_VEXAMSTUDENT_STATS') }}