WITH base_data AS (
    SELECT 
        e.*,
        s.SiteID AS SiteID,
        o.OfferingID AS OfferingID,
        o.SID AS CollegeLevelCode
    FROM CURRICULUM_DB.stg.stg_onegrade__estactva AS e
    LEFT JOIN CURRICULUM_DB.stg.stg_onegrade__course AS c 
        ON e.CourseCode = c.CourseCode 
        AND e.AcademicYearID = c.AcademicYearID
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__offering AS o 
        ON o.Code = c.CourseCode 
        AND o.AcademicYearID = c.AcademicYearID
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__site AS s 
        ON s.SiteID = o.SiteID
    WHERE e.CompletionID IN (1,2,3)
),
unpivot_helper AS (
    SELECT 1 AS MonitoringPointID UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5 UNION ALL
    SELECT 6
)

SELECT 
    md5(cast(coalesce(cast(TRIM(base.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS AcademicYear
    , md5(cast(coalesce(cast(TRIM(base.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(base.StudentRef) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS StudentKey
    , md5(cast(coalesce(cast(TRIM(base.OfferingID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CourseKey
    ,md5(cast(coalesce(cast(TRIM(base.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(base.StudentRef) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(base.CourseCode) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(base.LearningAimRef) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(CAST(base.StartDate AS DATE) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(CAST(base.CompletionID AS INTEGER) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS EnrolmentKey
    , md5(cast(coalesce(cast(TRIM(base.SiteID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS SiteKey
    , md5(cast(coalesce(cast(TRIM(base.CollegeLevelCode) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CollegeLevelKey
    , md5(cast(coalesce(cast(TRIM(base.Cohort) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CohortKey
    , md5(cast(coalesce(cast(base.VA_Type as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS VATypeKey
    ,md5(cast(coalesce(cast(TRIM(AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(LearningAimRef) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS LearningAimKey
    , CAST(CASE
        WHEN base.Cohort IN ('A level', 'Academic') THEN base.QOEPoints_GCSE_College2dp
        ELSE base.QOEPoints_College2dp
    END AS DECIMAL(19,2)) AS PriorAttainmentPoint

    , CAST(base.MostRecentCollegeEstGrade AS VARCHAR(50)) AS MinimumTargetGrade  
    , CAST(base.MostRecentCollegeEstGradeNo AS INTEGER) AS MinimumTargetGradeNo
    , CAST(base.MostRecentCollegeEstGradeInflated AS VARCHAR(50)) AS AspirationalTargetGrade     
    , CAST(base.MostRecentCollegeEstPoints2dp AS DECIMAL(19,2)) AS MinimumTargetPoints
    , CAST(base.PersonalTargetGrade AS VARCHAR(50)) AS PersonalTargetGrade
    , CAST(base.IYMostRecentGradeNo AS INTEGER) AS IYMostRecentGradeNumeric
    , CAST(base.IYMostRecent_vs_RecentTarget_NationalBanding AS VARCHAR(20)) AS BandingCategory

    , CAST(h.MonitoringPointID AS INTEGER) AS MPKey
    , CAST(CASE 
        WHEN h.MonitoringPointID = 1 THEN base.Point1_Grade
        WHEN h.MonitoringPointID = 2 THEN base.Point2_Grade
        WHEN h.MonitoringPointID = 3 THEN base.Point3_Grade
        WHEN h.MonitoringPointID = 4 THEN base.Point4_Grade
        WHEN h.MonitoringPointID = 5 THEN base.Point5_Grade
        WHEN h.MonitoringPointID = 6 THEN base.EnrolmentGrade
      END AS VARCHAR(20)) AS CurrentGrade
    , CAST(CASE 
        WHEN h.MonitoringPointID = 1 THEN base.Point1_Points
        WHEN h.MonitoringPointID = 2 THEN base.Point2_Points
        WHEN h.MonitoringPointID = 3 THEN base.Point3_Points
        WHEN h.MonitoringPointID = 4 THEN base.Point4_Points
        WHEN h.MonitoringPointID = 5 THEN base.Point5_Points
        WHEN h.MonitoringPointID = 6 THEN base.EnrolmentPoints
      END AS DECIMAL(19,2)) AS CurrentPoint
    , CAST(CASE 
        WHEN h.MonitoringPointID = 1 THEN base.Point1_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 2 THEN base.Point2_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 3 THEN base.Point3_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 4 THEN base.Point4_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 5 THEN base.Point5_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 6 THEN base.EnrolmentGradeVAScore_vs_MostRecent2dp
      END AS DECIMAL(19,2)) AS ValueAdded
    , CASE 
        WHEN base.MostRecentAtTarget = 1 THEN 'On Target'
        WHEN base.MostRecentAboveTarget = 1 THEN 'Above Target'
        WHEN base.MostRecentBelowTarget = 1 THEN 'Below Target'
    END AS TargetBand

    , CAST(CASE 
        WHEN base.VA_Type = 'L3VA' AND base.AgeOn31Aug IN (16,17,18) AND base.CompletionID IN (1,2) THEN 'L3VA Rules'
        WHEN base.VA_Type = 'CA' AND base.AgeOn31Aug IN (16,17,18) AND base.CompletionID IN (1,2,3) AND base.IsGraded='Yes' 
            AND base.WDNumDaysAfterStart IS NULL OR base.WDNumDaysAfterStart >= 42 THEN 'CA Rules'
    END AS VARCHAR(20)) AS DfeIncluded
    , CAST(base.Size AS DECIMAL(19,2)) AS QualificationSize
FROM base_data AS base
CROSS JOIN unpivot_helper AS h