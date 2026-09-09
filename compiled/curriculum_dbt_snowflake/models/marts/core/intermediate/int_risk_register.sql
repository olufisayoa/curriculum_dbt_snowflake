WITH prosolution_enrolments AS (
    SELECT
    md5(cast(coalesce(cast(TRIM(o.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(sd.RefNo) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(o.Code) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(o.QualID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(CAST(e.StartDate AS DATE) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(CAST(e.CompletionStatusID AS INTEGER) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS EnrolmentKey,
    md5(cast(coalesce(cast(TRIM(o.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS AcademicYearKey,
    md5(cast(coalesce(cast(TRIM(s.SiteID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS SiteKey,
    md5(cast(coalesce(cast(TRIM(o.SID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CollegeLevelKey,
    md5(cast(coalesce(cast(TRIM(sd.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(sd.RefNo) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS StudentKey,
    md5(cast(coalesce(cast(e.OfferingID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CourseKey
    FROM CURRICULUM_DB.stg.stg_prosolution__enrolment e
    INNER JOIN CURRICULUM_DB.stg.stg_prosolution__offering AS o ON o.OfferingID = e.OfferingID
    INNER JOIN CURRICULUM_DB.stg.stg_prosolution__student sd   ON e.StudentDetailID = sd.StudentDetailID
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__academicyear ay ON TRIM(ay.AcademicYearID) = TRIM(o.AcademicYearID)
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__site AS s 
        ON s.SiteID = o.SiteID
    WHERE ay.Number BETWEEN YEAR(CURRENT_DATE()) - 2 AND YEAR(CURRENT_DATE())
),
onegrade_enrolments AS (
    SELECT 
        md5(cast(coalesce(cast(TRIM(e.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(e.StudentRef) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(e.CourseCode) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(e.LearningAimRef) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(CAST(e.StartDate AS DATE) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(CAST(e.CompletionID AS INTEGER) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS EnrolmentKey,
         md5(cast(coalesce(cast(TRIM(e.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS AcademicYearKey,
        md5(cast(coalesce(cast(TRIM(e.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(e.StudentRef) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS StudentKey,
       md5(cast(coalesce(cast(TRIM(s.SiteID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS SiteKey,
       md5(cast(coalesce(cast(TRIM(o.SID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CollegeLevelKey,
       md5(cast(coalesce(cast(TRIM(e.Cohort) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CohortKey,
       md5(cast(coalesce(cast(e.VA_Type as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS VATypeKey,
       md5(cast(coalesce(cast(TRIM(e.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(e.LearningAimRef) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS LearningAimKey,
       md5(cast(coalesce(cast(TRIM(o.OfferingID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CourseKey,
        e.Size,
        e.CourseCode,
        e.LearningAimRef,
        e.StartDate,
        e.Cohort,
        e.CompletionID,
        e.QOEPoints_GCSE_College2dp,
        e.QOEPoints_College2dp,
        e.MostRecentCollegeEstGrade,
        e.MostRecentCollegeEstGradeNo,
        e.MostRecentCollegeEstGradeInflated,
        e.MostRecentCollegeEstPoints2dp,
        e.PersonalTargetGrade,
        e.IYMostRecentGradeNo,
        e.IYMostRecent_vs_RecentTarget_NationalBanding,
        e.Point1_Grade,
        e.Point2_Grade,
        e.Point3_Grade,
        e.Point4_Grade,
        e.Point5_Grade,
        e.EnrolmentGrade,
        e.Point1_Points,
        e.Point2_Points,
        e.Point3_Points,
        e.Point4_Points,
        e.Point5_Points,
        e.EnrolmentPoints,
        e.Point1_vs_MostRecent2dp,
        e.Point2_vs_MostRecent2dp,
        e.Point3_vs_MostRecent2dp,
        e.Point4_vs_MostRecent2dp,
        e.Point5_vs_MostRecent2dp,
        e.EnrolmentGradeVAScore_vs_MostRecent2dp
    FROM CURRICULUM_DB.stg.stg_onegrade__estactva AS e
    LEFT JOIN CURRICULUM_DB.stg.stg_onegrade__course AS c 
        ON e.CourseCode = c.CourseCode 
        AND e.AcademicYearID = c.AcademicYearID
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__offering AS o 
        ON o.Code = c.CourseCode 
        AND o.AcademicYearID = c.AcademicYearID
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__site AS s 
        ON s.SiteID = o.SiteID
    --WHERE e.VA_Type = 'L3VA' AND e.AgeOn31Aug IN (16,17,18) AND e.CompletionID IN (1,2)
),
consolidated_enrolments AS (
    SELECT
        COALESCE(p.EnrolmentKey, b.EnrolmentKey) AS EnrolmentKey,
        COALESCE(p.CollegeLevelKey, b.CollegeLevelKey) AS CollegeLevelKey,
        COALESCE(p.StudentKey, b.StudentKey) AS StudentKey,
        COALESCE(p.CourseKey, b.CourseKey) AS CourseKey,
        COALESCE(p.SiteKey, b.SiteKey) AS SiteKey,
        b.QOEPoints_GCSE_College2dp,
        b.QOEPoints_College2dp,
        CAST(CASE
          WHEN b.Cohort IN ('A level', 'Academic') THEN b.QOEPoints_GCSE_College2dp
          ELSE b.QOEPoints_College2dp
       END AS DECIMAL(19,2)) AS PriorAttainmentPoint,
        b.MostRecentCollegeEstGrade,
        b.MostRecentCollegeEstGradeNo,
        b.MostRecentCollegeEstGradeInflated,
        b.MostRecentCollegeEstPoints2dp,
        b.PersonalTargetGrade,
        b.IYMostRecentGradeNo,
        b.IYMostRecent_vs_RecentTarget_NationalBanding,
        b.Point1_Grade,
        b.Point2_Grade,
        b.Point3_Grade,
        b.Point4_Grade,
        b.Point5_Grade,
        b.EnrolmentGrade,
        b.Point1_Points,
        b.Point2_Points,
        b.Point3_Points,
        b.Point4_Points,
        b.Point5_Points,
        b.EnrolmentPoints,
        b.Point1_vs_MostRecent2dp,
        b.Point2_vs_MostRecent2dp,
        b.Point3_vs_MostRecent2dp,
        b.Point4_vs_MostRecent2dp,
        b.Point5_vs_MostRecent2dp,
        b.EnrolmentGradeVAScore_vs_MostRecent2dp
    FROM prosolution_enrolments p
    LEFT JOIN onegrade_enrolments b 
        ON p.EnrolmentKey = b.EnrolmentKey
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
    e.EnrolmentKey AS "EnrolmentKey",
    e.StudentKey AS "StudentKey",
    e.CollegeLevelKey AS "CollegeLevelKey",
    e.CourseKey AS "CourseKey",
    e.SiteKey AS "SiteKey",
    e.PriorAttainmentPoint AS "PriorAttainmentPoint",
    CAST(e.MostRecentCollegeEstGrade AS VARCHAR(50)) AS "MTG",
    CAST(e.MostRecentCollegeEstGradeInflated AS VARCHAR(50)) AS "ATG",
    CAST(e.PersonalTargetGrade AS VARCHAR(50)) AS "PTG",
    CAST(h.MonitoringPointID AS INTEGER) AS "MPKey",
    CAST(CASE 
        WHEN h.MonitoringPointID = 1 THEN e.Point1_Grade
        WHEN h.MonitoringPointID = 2 THEN e.Point2_Grade
        WHEN h.MonitoringPointID = 3 THEN e.Point3_Grade
        WHEN h.MonitoringPointID = 4 THEN e.Point4_Grade
        WHEN h.MonitoringPointID = 5 THEN e.Point5_Grade
        WHEN h.MonitoringPointID = 6 THEN e.EnrolmentGrade
      END AS VARCHAR(20)) AS "Current Grade",
    CAST(CASE 
        WHEN h.MonitoringPointID = 1 THEN e.Point1_Points
        WHEN h.MonitoringPointID = 2 THEN e.Point2_Points
        WHEN h.MonitoringPointID = 3 THEN e.Point3_Points
        WHEN h.MonitoringPointID = 4 THEN e.Point4_Points
        WHEN h.MonitoringPointID = 5 THEN e.Point5_Points
        WHEN h.MonitoringPointID = 6 THEN e.EnrolmentPoints
      END AS DECIMAL(19,2)) AS "Current Point",
    CAST(CASE 
        WHEN h.MonitoringPointID = 1 THEN e.Point1_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 2 THEN e.Point2_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 3 THEN e.Point3_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 4 THEN e.Point4_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 5 THEN e.Point5_vs_MostRecent2dp
        WHEN h.MonitoringPointID = 6 THEN e.EnrolmentGradeVAScore_vs_MostRecent2dp
      END AS DECIMAL(19,2)) AS "Value Added"
FROM consolidated_enrolments e
CROSS JOIN unpivot_helper h