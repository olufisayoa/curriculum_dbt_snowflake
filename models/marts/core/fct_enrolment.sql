SELECT
"EnrolmentKey",
{{ dbt_utils.generate_surrogate_key(['TRIM("AcademicYear")']) }} AS "AcademicYearKey",
{{ dbt_utils.generate_surrogate_key(['TRIM("AcademicYear")', 'TRIM("StudentID")']) }} AS "StudentKey",
"TotalPresent",
"TotalRequired",
"AttendanceRate" AS "Attendance",
"AttendanceScore"
FROM {{ ref('int_consolidated_enrolments') }}