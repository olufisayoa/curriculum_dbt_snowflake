with student_code_mapping as (
    select

        {{ dbt_utils.generate_surrogate_key(['TRIM(AcademicYearID)','TRIM(StudentID)']) }} AS StudentKey,
        StudentID,
        AcademicYearID,
        StudentCode
    from {{ source('Promonitor', 'PROMONITOR_STUDENTCODEMAPPING') }}    
)

SELECT
    StudentKey,
    StudentID,
    AcademicYearID,
    StudentCode
FROM student_code_mapping