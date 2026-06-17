WITH college_hierarchy AS (
    SELECT * FROM CURRICULUM_DB.RAW.PROSOLUTION_VCOLLEGELEVEL_INFO
)
SELECT
        md5(cast(coalesce(cast(SID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "CollegeLevelKey",
        COALESCE(Level4Description::VARCHAR(165), '-') AS "ProgramArea",
        COALESCE(Level3Description::VARCHAR(165), '-') AS "Department",
        COALESCE(Level2Description::VARCHAR(165), '-') AS "Campus",
        COALESCE(Level1Description::VARCHAR(165), '-') AS "Company",
        COALESCE(Level0Description::VARCHAR(165), '-') AS "Group"
FROM college_hierarchy