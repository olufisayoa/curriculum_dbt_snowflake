
  
    

create or replace transient table CURRICULUM_DB.int.int_student_enrolment_status
    
    
    
    as (SELECT
    md5(cast(coalesce(cast(TRIM("AcademicYear") as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM("StudentID") as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "StudentKey",
    TRIM("AcademicYear")            AS "AcademicYear",
    TRIM("StudentID")               AS "StudentID",
    'Yes'                           AS "IsEnrolled"
FROM CURRICULUM_DB.int.int_consolidated_enrolments
WHERE "CompletionStatus" = 'Continuing'
  AND "StartDate" <= current_date()
  AND "ActualEndDate" IS NULL
GROUP BY 1, 2, 3
    )
;


  