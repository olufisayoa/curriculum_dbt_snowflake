SELECT
S.StudentID,
S.AcademicYearID,
S.PMStudentID
FROM {{ source('Promonitor', 'PROMONITOR_VSTUDENT') }} S