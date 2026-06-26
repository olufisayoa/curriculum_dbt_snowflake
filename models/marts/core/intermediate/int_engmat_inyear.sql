with base as (
    select 
    e."ID" AS EnrolmentID,
    e."EngMatType" AS EngMatType,
    e."AcademicYearID" AS AcademicYearID,
    e."StudentRef" AS StudentRef,
    e."LearningAimRef" AS LearningAimRef,
    e."CourseCode" AS CourseCode,
    e."StartDate" AS StartDate,
    e."CompletionID" AS CompletionID,
    e."PriorAttainment_KS4" AS PriorAttainment_KS4,
    e."EnrolmentGrade" AS EnrolmentGrade,
    e."Progress" AS Progress,
    e."CappedProgress" AS CappedProgress,
    e."CurrentYear" AS CurrentYear,
    e."MostRecentIYGrade" AS MostRecentIYGrade,
    e."TargetGrade" AS TargetGrade,
    e."PersonalTargetGrade" AS PersonalTargetGrade,
    e."TargetPoints" AS TargetPoints,
    e."StartPoints" AS StartPoints,
    e."IYGrade1" AS IYGrade1,
    e."IYGrade2" AS IYGrade2,
    e."IYGrade3" AS IYGrade3,
    e."IYGrade4" AS IYGrade4,
    e."IYGrade5" AS IYGrade5,
    e."IYPoints1" AS IYPoints1,
    e."IYPoints2" AS IYPoints2,
    e."IYPoints3" AS IYPoints3,
    e."IYPoints4" AS IYPoints4,
    e."IYPoints5" AS IYPoints5,
    e."IYProgress1" AS IYProgress1,
    e."IYProgress2" AS IYProgress2,
    e."IYProgress3" AS IYProgress3,
    e."IYProgress4" AS IYProgress4,
    e."IYProgress5" AS IYProgress5,
    e."CappedPoints" AS CappedPoints,
    s.SiteID AS SiteID,
    o.OfferingID AS OfferingID,
    o.SID AS CollegeLevelCode
    from {{ ref('stg_onegrade__engmat_enrolment_inyear') }} as e
    LEFT JOIN {{ ref('stg_onegrade__course') }} AS c 
        ON e."CourseCode" = c.CourseCode 
        AND e."AcademicYearID" = c.AcademicYearID
    LEFT JOIN {{ ref('stg_prosolution__offering') }} AS o 
        ON o.Code = c.CourseCode 
        AND o.AcademicYearID = c.AcademicYearID
    LEFT JOIN {{ ref('stg_prosolution__site') }} AS s 
        ON s.SiteID = o.SiteID

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
    {{ dbt_utils.generate_surrogate_key(['TRIM(base.AcademicYearID)']) }} AS AcademicYearKey
    , {{ dbt_utils.generate_surrogate_key(['TRIM(base.AcademicYearID)', 'TRIM(base.StudentRef)']) }} AS StudentKey
    , {{ dbt_utils.generate_surrogate_key(['TRIM(base.OfferingID)']) }} AS CourseKey
    ,{{ dbt_utils.generate_surrogate_key([
    'TRIM(base.AcademicYearID)',   
    'TRIM(base.StudentRef)',
    'TRIM(base.CourseCode)',   
    'TRIM(base.LearningAimRef)',            
    'CAST(base.StartDate AS DATE)',      
    'CAST(base.CompletionID AS INTEGER)'                            
    ]) }} AS EnrolmentKey
    , {{ dbt_utils.generate_surrogate_key(['TRIM(base.SiteID)']) }} AS SiteKey
    , {{ dbt_utils.generate_surrogate_key(['TRIM(base.CollegeLevelCode)']) }} AS CollegeLevelKey
    ,CAST(CASE 
        WHEN base.EngMatType='English' THEN 1
        WHEN base.EngMatType='Maths' THEN 2
        ELSE 3
    END AS INTEGER) AS SubjectKey
    ,base.PriorAttainment_KS4
    ,base.EnrolmentGrade
    ,base.Progress
    ,base.CappedProgress
    ,base.CurrentYear
    ,base.MostRecentIYGrade
    ,base.TargetGrade
    ,base.PersonalTargetGrade
    ,base.TargetPoints
    , CAST(h.MonitoringPointID AS INTEGER) AS MPKey
    , CAST(CASE 
        WHEN h.MonitoringPointID = 1 THEN base.IYGrade1
        WHEN h.MonitoringPointID = 2 THEN base.IYGrade2
        WHEN h.MonitoringPointID = 3 THEN base.IYGrade3
        WHEN h.MonitoringPointID = 4 THEN base.IYGrade4
        WHEN h.MonitoringPointID = 5 THEN base.IYGrade5
        WHEN h.MonitoringPointID = 6 THEN base.EnrolmentGrade
      END AS VARCHAR(20)) AS CurrentGrade
    , CAST(CASE 
        WHEN h.MonitoringPointID = 1 THEN base.IYPoints1
        WHEN h.MonitoringPointID = 2 THEN base.IYPoints2
        WHEN h.MonitoringPointID = 3 THEN base.IYPoints3
        WHEN h.MonitoringPointID = 4 THEN base.IYPoints4
        WHEN h.MonitoringPointID = 5 THEN base.IYPoints5
        WHEN h.MonitoringPointID = 6 THEN base.CappedPoints
      END AS DECIMAL(19,2)) AS CurrentPoint
    , CAST(CASE 
        WHEN h.MonitoringPointID = 1 THEN base.IYProgress1
        WHEN h.MonitoringPointID = 2 THEN base.IYProgress2
        WHEN h.MonitoringPointID = 3 THEN base.IYProgress3
        WHEN h.MonitoringPointID = 4 THEN base.IYProgress4
        WHEN h.MonitoringPointID = 5 THEN base.IYProgress5
        WHEN h.MonitoringPointID = 6 THEN base.CappedProgress
      END AS DECIMAL(19,2)) AS InYearProgress

FROM base
CROSS JOIN unpivot_helper AS h