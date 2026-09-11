SELECT 
    StudentKey AS "StudentKey",
    AcademicYearKey AS "AcademicYearKey",
    SUM(MrkPresent) as "MrkPresent",
    SUM(MrkRequired) as "MrkRequired",
    DIV0(SUM(MrkPresent), SUM(MrkRequired)) as "AttendanceRate"
FROM {{ ref('int_attendance') }}
GROUP BY 1, 2