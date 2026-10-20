WITH Enrolments AS (
    SELECT * FROM {{ ref('int_consolidated_enrolments') }}
    WHERE CompletionStatus IN (1,2)
)   

SELECT  "EnrolmentKey",
    {{ dbt_utils.generate_surrogate_key(['TRIM("AcademicYear")', 'TRIM("StudentID")']) }} AS "StudentKey",
    {{ dbt_utils.generate_surrogate_key(['OfferingID', 'OfferingGroupID'] ) }} AS "CourseKey",
    {{ dbt_utils.generate_surrogate_key(['TRIM("AcademicYear")'] ) }} AS "AcademicYearKey",
    {{ dbt_utils.generate_surrogate_key(['TRIM(CollegeLevelCode)'] ) }} AS "CollegeLevelKey",
    "StartDate",
    "ActualEndDate",
    TO_NUMBER(TO_CHAR("StartDate", 'YYYYMMDD')) AS "StartDateKey",
    1 AS "EnrolmentCount"
FROM Enrolments