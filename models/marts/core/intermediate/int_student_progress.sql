WITH base_data AS (
    SELECT 
        e.*,
        s.SiteID AS SiteID,
        o.OfferingID AS OfferingID,
        o.SID AS CollegeLevelCode
    FROM {{ ref('stg_onegrade__estactva') }} AS e
    LEFT JOIN {{ ref('stg_onegrade__course') }} AS c 
        ON e.CourseCode = c.CourseCode 
        AND e.AcademicYearID = c.AcademicYearID
    LEFT JOIN {{ ref('stg_prosolution__offering') }} AS o 
        ON o.Code = c.CourseCode 
        AND o.AcademicYearID = c.AcademicYearID
    LEFT JOIN {{ ref('stg_prosolution__site') }} AS s 
        ON s.SiteID = o.SiteID
    WHERE e.CompletionID IN (1,2)
),
unpivot_helper AS (
    SELECT 1 AS MonitoringPointID UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5
)

SELECT 
    {{ dbt_utils.generate_surrogate_key(['TRIM(base.AcademicYearID)']) }} AS AcademicYear
    , {{ dbt_utils.generate_surrogate_key(['TRIM(base.AcademicYearID)','TRIM(base.StudentRef)']) }} AS StudentKey
    , {{ dbt_utils.generate_surrogate_key(['TRIM(base.OfferingID)']) }} AS CourseKey
    ,{{ dbt_utils.generate_surrogate_key(['TRIM(base.AcademicYearID)','TRIM(base.StudentRef)','TRIM(base.LearningAimRef)','TRIM(base.StartDate)','TRIM(base.CompletionID)','TRIM(base.CourseCode)']) }} AS EnrolmentKey
    , {{ dbt_utils.generate_surrogate_key(['TRIM(base.SiteID)']) }} AS SiteKey
    , CAST(base.CollegeLevelCode AS INT) AS CollegeLevelCode
    , {{ dbt_utils.generate_surrogate_key(['TRIM(base.Cohort)']) }} AS CohortKey
    
    , CAST(CASE
        WHEN base.Cohort IN ('A Level', 'Academic') THEN base.QOEPoints_GCSE_College2dp
        WHEN base.Cohort IN ('Applied General','None','Tech Level VA') THEN base.QOEPoints_College2dp
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
      END AS VARCHAR(20)) AS CurrentGrade
    , CAST(CASE 
        WHEN h.MonitoringPointID = 1 THEN base.Point1_Points
        WHEN h.MonitoringPointID = 2 THEN base.Point2_Points
        WHEN h.MonitoringPointID = 3 THEN base.Point3_Points
        WHEN h.MonitoringPointID = 4 THEN base.Point4_Points
        WHEN h.MonitoringPointID = 5 THEN base.Point5_Points
      END AS DECIMAL(19,2)) AS CurrentPoint
    , CAST(CASE 
        WHEN h.MonitoringPointID = 1 THEN base.Point1_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 2 THEN base.Point2_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 3 THEN base.Point3_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 4 THEN base.Point4_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 5 THEN base.Point5_vs_MostRecent2dp
      END AS DECIMAL(19,2)) AS ValueAdded

    , CAST(base.EnrolmentGrade AS VARCHAR(20)) AS EnrolmentGrade
    , CAST(base.EnrolmentPoints AS DECIMAL(19,2)) AS EnrolmentPoint

    , CASE 
        WHEN base.MostRecentAtTarget = 1 THEN 'On Target'
        WHEN base.MostRecentAboveTarget = 1 THEN 'Above Target'
        WHEN base.MostRecentBelowTarget = 1 THEN 'Below Target'
    END AS TargetBand

    , CAST(CASE 
        WHEN base.VA_Type = 'L3VA' AND base.AgeOn31Aug IN (16,17,18) AND base.CompletionID IN (1,2) THEN 1
    END AS BOOLEAN) AS DfeIncluded

FROM base_data AS base
CROSS JOIN unpivot_helper AS h