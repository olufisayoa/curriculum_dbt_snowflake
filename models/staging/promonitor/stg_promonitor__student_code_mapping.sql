with student_code_mapping as (
    select

        {{ dbt_utils.generate_surrogate_key(['TRIM(AcademicYearID)','TRIM(StudentID)']) }} AS StudentKey,
        StudentID,
        AcademicYearID,
        StudentCode,
        row_number() over (partition by TRIM(AcademicYearID), TRIM(StudentID) order by StudentCode) as rn
    from {{ source('Promonitor', 'PROMONITOR_STUDENTCODEMAPPING') }}    
)

SELECT
    StudentKey,
    StudentID,
    AcademicYearID,
    StudentCode
FROM student_code_mapping
WHERE rn = 1