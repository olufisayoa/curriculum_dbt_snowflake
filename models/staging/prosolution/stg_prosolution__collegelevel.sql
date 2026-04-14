WITH college_hierarchy AS (
    SELECT * FROM {{ source('ProSolution', 'PROSOLUTION_VCOLLEGELEVEL_INFO') }}
)
SELECT
        {{ dbt_utils.generate_surrogate_key(['SID']) }} AS "CollegeLevelKey",
        COALESCE(Level4Description::VARCHAR(165), '-') AS "ProgramArea",
        COALESCE(Level3Description::VARCHAR(165), '-') AS "Department",
        COALESCE(Level2Description::VARCHAR(165), '-') AS "Campus",
        COALESCE(Level1Description::VARCHAR(165), '-') AS "Company",
        COALESCE(Level0Description::VARCHAR(165), '-') AS "Group"
FROM college_hierarchy
