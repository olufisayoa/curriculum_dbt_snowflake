WITH Enrolments AS (
    SELECT * FROM CURRICULUM_DB.int.int_consolidated_enrolments
)

SELECT  "EnrolmentKey",
    md5(cast(coalesce(cast(TRIM("AcademicYear") as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM("StudentID") as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "StudentKey",
    md5(cast(coalesce(cast(OfferingID as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(OfferingGroupID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "CourseKey",
    md5(cast(coalesce(cast(TRIM("AcademicYear") as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "AcademicYearKey",
    "StartDate",
    "ActualEndDate",
    TO_NUMBER(TO_CHAR("StartDate", 'YYYYMMDD')) AS "StartDateKey",
    1 AS "EnrolmentCount"
FROM Enrolments