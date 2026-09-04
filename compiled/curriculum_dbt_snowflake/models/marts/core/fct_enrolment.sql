SELECT
"EnrolmentKey",
md5(cast(coalesce(cast(TRIM("AcademicYear") as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "AcademicYearKey",
md5(cast(coalesce(cast(TRIM("AcademicYear") as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM("StudentID") as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "StudentKey",
"TotalPresent",
"TotalRequired",
"AttendanceRate" AS "Attendance",
"AttendanceScore"
FROM CURRICULUM_DB.int.int_consolidated_enrolments