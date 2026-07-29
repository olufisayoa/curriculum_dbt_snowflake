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
								
	FROM {{ ref('stg_onegrade__enrolment') }} E
	INNER JOIN {{ ref('stg_onegrade__staff_teaching_group') }} STG ON STG.AcademicYearID = E.AcademicYearID AND	STG.TeachingGroupCode = E.TeachingGroupCode
	INNER JOIN {{ ref('stg_onegrade__course') }} C ON	E.AcademicYearID = C.AcademicYearID AND	E.CourseID = C.ID
	LEFT JOIN {{ ref('stg_prosolution__offering') }} O ON O.AcademicYearID = C.AcademicYearID AND O.Code = C.CourseCode
	INNER JOIN {{ ref('stg_onegrade__student') }} S ON E.StudentID = S.ID
	LEFT JOIN {{ ref('stg_onegrade__inyeargrade') }} G ON	E.AcademicYearID = G.AcademicYearID AND	E.StudentID = G.StudentID AND E.CourseID = G.CourseID
	LEFT JOIN {{ ref('stg_onegrade__staff') }} ST ON ST.StaffID = STG.StaffID
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
       {{ dbt_utils.generate_surrogate_key(['TRIM(AcademicYearID)']) }} AS AcademicYearKey,
       {{ dbt_utils.generate_surrogate_key(['TRIM(AcademicYearID)', 'TRIM(StudentRef)']) }} AS StudentKey,
       {{ dbt_utils.generate_surrogate_key(['TRIM(OfferingID)']) }} AS CourseKey,
       {{ dbt_utils.generate_surrogate_key(['TRIM(CollegeLevel)']) }} AS CollegeLevelKey,
       {{ dbt_utils.generate_surrogate_key(['TRIM(SiteID)']) }} AS SiteKey,
	   MPKey,
       Forenames,
       Surname,
	   PointGrade,
	   PointEffort,
	   CASE WHEN PointGrade IS NULL OR LTRIM(RTRIM(PointGrade)) = '' THEN 0 ELSE 1 END AS PointGradeMarked,
	   CASE WHEN PointEffort IS NULL THEN 0 ELSE 1 END AS PointEffortMarked
FROM Unpivoted