with college_level AS (
    SELECT 
        "CollegeLevelKey" AS "CollegeLevelKey",
        ProgramAreaCode AS "ProgramAreaCode",
        ProgramAreaName AS "ProgramAreaName",
        ProgramAreaLevel AS "ProgramAreaLevel",
        DepartmentCode AS "DepartmentCode",
        DepartmentName AS "DepartmentName",
        DepartmentLevel AS "DepartmentLevel",
        CampusCode AS "CampusCode",
        CampusName AS "CampusName",
        CampusLevel AS "CampusLevel",
        CompanyCode AS "CompanyCode",
        CompanyName AS "CompanyName",
        CompanyLevel AS "CompanyLevel",
        GroupCode AS "GroupCode",
        GroupName AS "GroupName",
        GroupLevel AS "GroupLevel"
    FROM {{ ref('stg_prosolution__collegelevel') }}
)
SELECT * FROM college_level