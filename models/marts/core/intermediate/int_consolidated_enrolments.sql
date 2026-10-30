WITH  ProSolution_Master AS (
    SELECT 
        PSE.EnrolmentID                                      AS EnrolmentID,
        LTRIM(RTRIM(PSD.RefNo))                               AS StudentRef,
        LTRIM(RTRIM(PSO.Code))                               AS CourseCode,
        PSO.Name                                              AS CourseTitle,
        LTRIM(RTRIM(PSO.AcademicYearID))                     AS AcademicYearID,
        PSE.StartDate                                         AS StartDate,
        PSE.ExpectedEndDate                                   AS PlannedEndDate,
        PSE.ActualEndDate                                     AS ActualEndDate,
        PSC.Description                                       AS CompletionStatus,
        PSE.Grade                                             AS Grade,
        O.Description                                         AS Outcome,
        PSE.OfferingID                                        AS OfferingID,
        POG.OfferingGroupID                                   AS OfferingGroupID,
        PSE.CompletionStatusID                                AS CompletionStatusID,
        LTRIM(RTRIM(PSO.QualID))                              AS LearningAimRef,
        PSE.StudentDetailID                                   AS StudentDetailID,
        PSE.StudyYear                                         AS StudyYear,
        PSO.SID                                                AS CollegeLevelCode,
        ET.Description AS EnrolmentType
    FROM {{ ref('stg_prosolution__enrolment') }} PSE
    INNER JOIN {{ ref('stg_prosolution__student') }} PSD   ON PSE.StudentDetailID = PSD.StudentDetailID
    INNER JOIN {{ ref('stg_prosolution__offering') }} PSO       ON PSE.OfferingID = PSO.OfferingID
    LEFT JOIN {{ ref('stg_prosolution__offeringgroup') }} AS POG ON POG.OfferingID = PSO.OfferingID AND POG.OfferingGroupID = PSE.OfferingGroupID
    LEFT  JOIN {{ ref('stg_prosolution__completionstatus') }} PSC ON PSC.CompletionStatusID = PSE.CompletionStatusID
    LEFT  JOIN {{ ref('stg_prosolution__outcome') }} O           ON O.OutcomeID = PSE.OutcomeID
    LEFT JOIN {{ ref('stg_prosolution__enrolmenttype') }} ET      ON ET.EnrolmentTypeID = PSE.EnrolmentTypeID
),

OneGrade_Enrichment AS (
     SELECT 
         OGE.ID                    AS OneGradeEnrolmentID,
         LTRIM(RTRIM(OGE.StudentRef)) AS StudentRef,
         LTRIM(RTRIM(OGC.CourseCode)) AS CourseCode,
         LTRIM(RTRIM(OGE.AcademicYearID)) AS AcademicYearID,
         OGE.StartDate,
		 OGE.PlannedEndDate,
		 OGE.ActualEndDate,
		 OGC.Title AS CourseTitle,
         OGE.CompletionID,
		 OGE.VAType,
		 vla.QualType AS Cohort,
		 OGE.NotionalNVQLevel,
         OGE.WDNumDaysAfterStart,
		 ofq."QualificationLevel" AS QualificationLevel,
         OGE.AgeOn31Aug,
         LTRIM(RTRIM(OGE.LearningAimRef)) AS LearningAimRef,
         OGE.WholeQualID,
         OGE.CourseID              AS OneGradeCourseID,
		 C.Description AS CompletionStatus,
         ROW_NUMBER() OVER (PARTITION BY OGE.AcademicYearID, OGE.StudentRef, OGC.CourseCode, OGE.LearningAimRef, OGE.StartDate
         ORDER BY OGE.ID DESC) AS rn
     FROM {{ ref('stg_onegrade__estactva') }} OGE
     LEFT  JOIN {{ ref('stg_onegrade__course') }} OGC ON OGE.CourseID = OGC.ID
	 LEFT  JOIN {{ ref('stg_onegrade__completion') }} C ON C.ID=OGE.CompletionID
	 LEFT JOIN {{ ref('stg_onegrade__ofqual') }} ofq ON ofq."QualificationNumber"=OGE.LearningAimRef
	 LEFT JOIN {{ ref('stg_onegrade__learningaim') }} vla ON vla.LearningAimRef=OGE.LearningAimRef AND vla.WholeQualID=OGE.WholeQualID
     WHERE OGE.StudentRef IS NOT NULL
),
OneGrade_Enrichment_Deduped AS (
    SELECT 
        OneGradeEnrolmentID,
        StudentRef,
        CourseCode,
        AcademicYearID,
        StartDate,
        PlannedEndDate,
        ActualEndDate,
        LearningAimRef,
        CourseTitle,
        VA_Type,
        Cohort,
        NotionalNVQLevel,
        WDNumDaysAfterStart,
        QualificationLevel,
        AgeOn31Aug,
        CompletionID,
        CompletionStatus
    FROM OneGrade_Enrichment
    WHERE rn = 1 
),
Attendance_Aggregated AS (
    SELECT
        EnrolmentKey,
        SUM(MrkPresent)                             AS TotalPresent,
        SUM(MrkRequired)                            AS TotalRequired,
        DIV0(
            SUM(MrkPresent),
            SUM(MrkRequired)
        )                                           AS AttendanceRate
    FROM {{ ref('int_attendance') }}
    GROUP BY EnrolmentKey
),
Enrolments AS (
SELECT 

     {{ dbt_utils.generate_surrogate_key([
            'TRIM(COALESCE(PM.AcademicYearID, OE.AcademicYearID))',   
            'TRIM(COALESCE(PM.StudentRef, OE.StudentRef))',
            'TRIM(COALESCE(PM.CourseCode, OE.CourseCode))',   
            'TRIM(COALESCE(PM.LearningAimRef, OE.LearningAimRef))',            
            'CAST(COALESCE(PM.StartDate, OE.StartDate) AS DATE)'                            
        ]) }} AS "EnrolmentKey",
    CAST(COALESCE(TRIM(PM.AcademicYearID), TRIM(OE.AcademicYearID)) AS NCHAR(5)) AS "AcademicYear",
    CAST(COALESCE(PM.StudentRef, OE.StudentRef) AS NCHAR(50)) AS "StudentID",
    CAST(COALESCE(PM.CourseCode, OE.CourseCode) AS NVARCHAR(24)) AS "CourseCode",
    CAST(COALESCE(PM.CourseTitle, OE.CourseTitle, '-') AS NVARCHAR(255)) AS "CourseName",
    CAST(COALESCE(PM.StartDate, OE.StartDate) AS TIMESTAMP_NTZ) AS "StartDate",
    CAST(COALESCE(PM.PlannedEndDate, OE.PlannedEndDate) AS TIMESTAMP_NTZ) AS "PlannedEndDate",
    CAST(COALESCE(PM.ActualEndDate, OE.ActualEndDate) AS TIMESTAMP_NTZ) AS "ActualEndDate",
    CAST(COALESCE(PM.CompletionStatus, OE.CompletionStatus, '-') AS NVARCHAR(50)) AS "CompletionStatus",
        
    CAST(COALESCE(OE.NotionalNVQLevel, '-') AS NCHAR(1)) AS "NotionalNVQLevel",
    CAST(COALESCE(OE.WDNumDaysAfterStart, -1) AS INT) AS "WDNumDaysAfterStart",
    CAST(COALESCE(OE.AgeOn31Aug, -1) AS INT) AS "AgeOn31Aug",
    CAST(COALESCE(OE.VA_Type, '-') AS NVARCHAR(100)) AS "VAType",
    CAST(COALESCE(OE.Cohort, '-') AS NVARCHAR(20)) AS "Cohort",
    CAST(COALESCE(OE.QualificationLevel, '-') AS NVARCHAR(255)) AS "QualificationLevel",

    CAST(COALESCE(PM.StudyYear, 1) AS DECIMAL(19,2)) AS "StudyYear",
    CAST(COALESCE(PM.EnrolmentType, '-') AS NVARCHAR(100)) AS "EnrolmentType",
    CAST(COALESCE(PM.Outcome, '-') AS NVARCHAR(100)) AS "Outcome",
    PM.OfferingID,
    PM.OfferingGroupID,
    PM.CollegeLevelCode,
    PM.CompletionStatusID
FROM ProSolution_Master PM
FULL OUTER JOIN OneGrade_Enrichment_Deduped OE
        ON  TRIM(PM.AcademicYearID) = TRIM(OE.AcademicYearID)
        AND TRIM(PM.StudentRef)     = TRIM(OE.StudentRef)
        AND TRIM(PM.CourseCode)     = TRIM(OE.CourseCode)
        AND TRIM(PM.LearningAimRef) = TRIM(OE.LearningAimRef)
        AND CAST(PM.StartDate AS DATE) = CAST(OE.StartDate AS DATE)
)

SELECT
    E.*,
    CAST(COALESCE(A.TotalPresent, 0)  AS INT)           AS "TotalPresent",
    CAST(COALESCE(A.TotalRequired, 0) AS INT)           AS "TotalRequired",
    CAST(COALESCE(A.AttendanceRate, 0) AS DECIMAL(5,4)) AS "AttendanceRate",
    CASE 
        WHEN COALESCE(A.TotalRequired, 0) = 0 THEN NULL
        WHEN A.AttendanceRate >= 0.95 THEN 0
        WHEN A.AttendanceRate >= 0.90 THEN -1
        WHEN A.AttendanceRate >= 0.85 THEN -2
        WHEN A.AttendanceRate >= 0.80 THEN -3
        ELSE -4
    END AS "AttendanceScore"
FROM Enrolments E
LEFT JOIN Attendance_Aggregated A
    ON E."EnrolmentKey" = A.EnrolmentKey