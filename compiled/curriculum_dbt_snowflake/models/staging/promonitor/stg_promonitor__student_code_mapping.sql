with student_code_mapping as (
    select

        md5(cast(coalesce(cast(TRIM(AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(StudentID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS StudentKey,
        StudentID,
        AcademicYearID,
        StudentCode,
        row_number() over (partition by TRIM(AcademicYearID), TRIM(StudentID) order by StudentCode) as rn
    from CURRICULUM_DB.RAW.PROMONITOR_STUDENTCODEMAPPING    
)

SELECT
    StudentKey,
    StudentID,
    AcademicYearID,
    StudentCode
FROM student_code_mapping
WHERE rn = 1