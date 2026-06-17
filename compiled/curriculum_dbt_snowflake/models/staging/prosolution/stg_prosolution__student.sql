select
        md5(cast(coalesce(cast(TRIM(s.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(s.RefNo) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS StudentKey,
        s.*
    from CURRICULUM_DB.RAW.PROSOLUTION_STUDENTDETAIL AS s