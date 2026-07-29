WITH Compliance AS (
	SELECT E.AcademicYearID,
		   ST.Forenames,
		   ST.Surname,
		   E.StudentRef,
		   O.OfferingID, 
		   O.SiteID,
		   O.SID AS CollegeLevel,
		   C.CourseCode,
			G.Point1_Grade,
			G.Point2_Grade,
			G.Point3_Grade,
			G.Point4_Grade,
			G.Point5_Grade,
			G.Point1_EffortID,
			G.Point2_EffortID,
			G.Point3_EffortID,
			G.Point4_EffortID,
			G.Point5_EffortID
								
	FROM CURRICULUM_DB.stg.stg_onegrade__enrolment E
	INNER JOIN CURRICULUM_DB.stg.stg_onegrade__staff_teaching_group STG ON STG.AcademicYearID = E.AcademicYearID AND	STG.TeachingGroupCode = E.TeachingGroupCode
	INNER JOIN CURRICULUM_DB.stg.stg_onegrade__course C ON	E.AcademicYearID = C.AcademicYearID AND	E.CourseID = C.ID
	LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__offering O ON O.AcademicYearID = C.AcademicYearID AND O.Code = C.CourseCode
	INNER JOIN CURRICULUM_DB.stg.stg_onegrade__student S ON E.StudentID = S.ID
	LEFT JOIN CURRICULUM_DB.stg.stg_onegrade__inyeargrade G ON	E.AcademicYearID = G.AcademicYearID AND	E.StudentID = G.StudentID AND E.CourseID = G.CourseID
	LEFT JOIN CURRICULUM_DB.stg.stg_onegrade__staff ST ON ST.StaffID = STG.StaffID
	WHERE E.CompletionID=1
),
unpivot_helper AS (
    SELECT 1 AS MonitoringPointID UNION ALL
    SELECT 2 UNION ALL
    SELECT 3 UNION ALL
    SELECT 4 UNION ALL
    SELECT 5  
),
unpivoted AS (
	SELECT base.AcademicYearID,
		   base.Forenames,
		   base.Surname,
		   base.StudentRef,
		   base.OfferingID,
		   base.CollegeLevel,
		   base.SiteID,
		   base.CourseCode,
     CAST(h.MonitoringPointID AS INTEGER) AS MPKey,
    CAST(CASE 
        WHEN h.MonitoringPointID = 1 THEN base.Point1_Grade
        WHEN h.MonitoringPointID = 2 THEN base.Point2_Grade
        WHEN h.MonitoringPointID = 3 THEN base.Point3_Grade
        WHEN h.MonitoringPointID = 4 THEN base.Point4_Grade
        WHEN h.MonitoringPointID = 5 THEN base.Point5_Grade
      END AS VARCHAR(20)) AS PointGrade,
    CAST(CASE 
        WHEN h.MonitoringPointID = 1 THEN base.Point1_EffortID
        WHEN h.MonitoringPointID = 2 THEN base.Point2_EffortID
        WHEN h.MonitoringPointID = 3 THEN base.Point3_EffortID
        WHEN h.MonitoringPointID = 4 THEN base.Point4_EffortID
        WHEN h.MonitoringPointID = 5 THEN base.Point5_EffortID
      END AS INT) AS PointEffort
    
	FROM Compliance AS base
	CROSS JOIN unpivot_helper AS h
)
SELECT 
       md5(cast(coalesce(cast(TRIM(AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS AcademicYearKey,
       md5(cast(coalesce(cast(TRIM(AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(StudentRef) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS StudentKey,
       md5(cast(coalesce(cast(TRIM(OfferingID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CourseKey,
       md5(cast(coalesce(cast(TRIM(CollegeLevel) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS CollegeLevelKey,
       md5(cast(coalesce(cast(TRIM(SiteID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS SiteKey,
	   MPKey,
       Forenames,
       Surname,
	   PointGrade,
	   PointEffort,
	   CASE WHEN PointGrade IS NULL OR LTRIM(RTRIM(PointGrade)) = '' THEN 0 ELSE 1 END AS PointGradeMarked,
	   CASE WHEN PointEffort IS NULL THEN 0 ELSE 1 END AS PointEffortMarked
FROM Unpivoted