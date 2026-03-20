WITH college_level AS (
    SELECT * FROM {{ source('ProSolution', 'PROSOLUTION_COLLEGELEVEL') }}
),

college_level_num AS (
    SELECT * FROM {{ source('ProSolution', 'PROSOLUTION_COLLEGELEVELNUM') }}
),

college_hierarchy AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['L4.SID', 'L3.SID', 'L2.SID', 'L1.SID', 'L0.SID']) }} AS "CollegeLevelKey",
        COALESCE(L4.Code::CHAR(12), '-') AS ProgramAreaCode,
        COALESCE(L4.Name::VARCHAR(150), '-') AS ProgramAreaName,
        COALESCE(CLNum4.Description::VARCHAR(30), '-') AS ProgramAreaLevel,

        COALESCE(L3.Code::CHAR(12), '-') AS DepartmentCode,
        COALESCE(L3.Name::VARCHAR(150), '-') AS DepartmentName,
        COALESCE(CLNum3.Description::VARCHAR(30), '-') AS DepartmentLevel,

        COALESCE(L2.Code::CHAR(12), '-') AS CampusCode,
        COALESCE(L2.Name::VARCHAR(150), '-') AS CampusName,
        COALESCE(CLNum2.Description::VARCHAR(30), '-') AS CampusLevel,

        COALESCE(L1.Code::CHAR(12), '-') AS CompanyCode,
        COALESCE(L1.Name::VARCHAR(150), '-') AS CompanyName,
        COALESCE(CLNum1.Description::VARCHAR(30), '-') AS CompanyLevel,

        COALESCE(L0.Code::CHAR(12), '-') AS GroupCode,
        COALESCE(L0.Name::VARCHAR(150), '-') AS GroupName,
        COALESCE(CLNum0.Description::VARCHAR(30), '-') AS GroupLevel,

        L4.SID::INT AS ProgramAreaSID,
        COALESCE(L3.SID::INT, -1) AS DepartmentSID,
        COALESCE(L2.SID::INT, -1) AS CampusSID,
        COALESCE(L1.SID::INT, -1) AS CompanySID,
        COALESCE(L0.SID::INT, -1) AS GroupSID

    FROM college_level AS L4
    INNER JOIN college_level_num AS CLNum4
        ON L4.LevelNum = CLNum4.CollegeLevelNum
    LEFT JOIN college_level AS L3
        ON L4.ParentSID = L3.SID
    LEFT JOIN college_level_num AS CLNum3
        ON L3.LevelNum = CLNum3.CollegeLevelNum
    LEFT JOIN college_level AS L2
        ON L3.ParentSID = L2.SID
    LEFT JOIN college_level_num AS CLNum2
        ON L2.LevelNum = CLNum2.CollegeLevelNum
    LEFT JOIN college_level AS L1
        ON L2.ParentSID = L1.SID
    LEFT JOIN college_level_num AS CLNum1
        ON L1.LevelNum = CLNum1.CollegeLevelNum
    LEFT JOIN college_level AS L0
        ON L1.ParentSID = L0.SID
    LEFT JOIN college_level_num AS CLNum0
        ON L0.LevelNum = CLNum0.CollegeLevelNum
)

SELECT *
FROM college_hierarchy
