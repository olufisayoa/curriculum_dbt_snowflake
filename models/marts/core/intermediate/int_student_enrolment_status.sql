SELECT
    {{ dbt_utils.generate_surrogate_key(['TRIM("AcademicYear")', 'TRIM("StudentID")']) }} AS "StudentKey",
    TRIM("AcademicYear")            AS "AcademicYear",
    TRIM("StudentID")               AS "StudentID",
    'Yes'                           AS "IsEnrolled"
FROM {{ ref('int_consolidated_enrolments') }}
WHERE "CompletionStatus" = 'Continuing'
  AND "StartDate" <= current_date()
  AND "ActualEndDate" IS NULL
GROUP BY 1, 2, 3