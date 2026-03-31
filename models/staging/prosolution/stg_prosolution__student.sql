
    select
        {{ dbt_utils.generate_surrogate_key(['TRIM(s.StudentDetailID)']) }} AS StudentKey,
        s.*
    from {{ source('ProSolution', 'PROSOLUTION_STUDENTDETAIL') }} AS s
