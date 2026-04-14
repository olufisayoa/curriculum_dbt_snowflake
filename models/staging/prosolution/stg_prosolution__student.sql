
    select
        {{ dbt_utils.generate_surrogate_key(['TRIM(s.AcademicYearID)', 'TRIM(s.RefNo)']) }} AS StudentKey,
        s.*
    from {{ source('ProSolution', 'PROSOLUTION_STUDENTDETAIL') }} AS s
