WITH  ProSolution_Master AS (
    SELECT 
        PSE.EnrolmentID                                      AS ProSolutionEnrolmentID,
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
        PSE.OfferingID                                        AS ProSolutionOfferingID,
        PSE.CompletionStatusID                                AS CompletionStatusID,
        LTRIM(RTRIM(PSO.QualID))                              AS LearningAimRef,
        PSE.StudentDetailID                                   AS StudentDetailID,
        PSE.StudyYear                                         AS StudyYear,
        ET.Description AS EnrolmentType
    FROM {{ ref('stg_prosolution__enrolment') }} PSE
    INNER JOIN {{ ref('stg_prosolution__student') }} PSD   ON PSE.StudentDetailID = PSD.StudentDetailID
    INNER JOIN {{ ref('stg_prosolution__offering') }} PSO       ON PSE.OfferingID = PSO.OfferingID
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
         ROW_NUMBER() OVER (PARTITION BY OGE.AcademicYearID, OGE.StudentRef, OGC.CourseCode, OGE.LearningAimRef, OGE.StartDate, OGE.CompletionID
         ORDER BY OGE.ID DESC) AS rn
     FROM {{ ref('stg_onegrade__enrolment') }} OGE
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
        VAType,
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
EngMat_Enrichment AS (
    SELECT 
        e."ID" AS EnrolmentID,
        e."EngMatType" AS EngMatType,
        LTRIM(RTRIM(e."AcademicYearID")) AS AcademicYearID,
        LTRIM(RTRIM(e."StudentRef")) AS StudentRef,
        LTRIM(RTRIM(e."LearningAimRef")) AS LearningAimRef,
        LTRIM(RTRIM(e."CourseCode")) AS CourseCode,
        e."StartDate" AS StartDate,
        e."ActualEndDate" AS ActualEndDate,
        e."CompletionID" AS CompletionID,
    FROM {{ ref('stg_onegrade__engmat_enrolment_inyear') }} e
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
    'TRIM(PM.AcademicYearID)',   
    'TRIM(PM.StudentRef)',
    'TRIM(PM.CourseCode)',   
    'TRIM(PM.LearningAimRef)',            
    'CAST(PM.StartDate AS DATE)',      
    'CAST(PM.CompletionStatusID AS INTEGER)'                            
    ]) }} AS "EnrolmentKey",
    CAST(COALESCE(LTRIM(RTRIM(PM.AcademicYearID)), OE.AcademicYearID) AS NCHAR(5)) AS "AcademicYear",

    CAST(COALESCE(PM.StudentRef, OE.StudentRef) AS NCHAR(50)) AS "StudentID",

    CAST(COALESCE(PM.CourseCode, OE.CourseCode) AS NVARCHAR(24)) AS "CourseCode",

    CAST(COALESCE(PM.CourseTitle, OE.CourseTitle) AS NVARCHAR(255)) AS "CourseName",

    CAST(COALESCE(PM.StartDate, OE.StartDate) AS TIMESTAMP_NTZ ) AS "StartDate",

    CAST(COALESCE(PM.PlannedEndDate, OE.PlannedEndDate) AS TIMESTAMP_NTZ ) AS "PlannedEndDate",

    CAST(COALESCE(PM.ActualEndDate, OE.ActualEndDate) AS TIMESTAMP_NTZ)     
        AS "ActualEndDate",

    CAST(COALESCE(PM.CompletionStatus,OE.OnegradeCourseCompletionStatus) AS NVARCHAR(50)) AS "CompletionStatus",
	
    CAST(COALESCE(OE.NotionalNVQLevel, '-') AS NCHAR(1)) AS "NotionalNVQLevel",

	CAST(COALESCE(OE.WDNumDaysAfterStart, -1) AS INT) AS "WDNumDaysAfterStart",

	CAST(COALESCE(OE.AgeOn31Aug, -1) AS INT) AS "AgeOn31Aug",

    CAST(COALESCE(OE.VAType, '-') AS NVARCHAR(100)) 
        AS "VAType",

	CAST(COALESCE(OE.Cohort, '-')  AS NVARCHAR(20)) AS "Cohort",
    CAST(COALESCE(OE.QualificationLevel, '-') AS NVARCHAR(255)) 
        AS "QualificationLevel",

    CAST(PM.StudyYear AS DECIMAL(19,2)) 
        AS "StudyYear",
    CAST(PM.EnrolmentType AS NVARCHAR(100)) 
        AS "EnrolmentType",
	CAST(COALESCE(PM.Outcome, '-') AS NVARCHAR(100)) 
        AS "Outcome",
    CAST(COALESCE(EM.EngMatType, 'Other') AS NVARCHAR(8))
        AS "SubjectType"

FROM ProSolution_Master PM
LEFT JOIN OneGrade_Enrichment_Deduped OE
    ON  PM.StudentRef   = OE.StudentRef
    AND PM.CourseCode  = OE.CourseCode
    AND PM.AcademicYearID            = OE.AcademicYearID
	AND PM.StartDate                  = OE.StartDate
    AND PM.LearningAimRef            = OE.LearningAimRef
    AND PM.CompletionStatusID          = OE.CompletionID
LEFT JOIN EngMat_Enrichment EM
    ON  PM.StudentRef   = EM.StudentRef
    AND PM.CourseCode  = EM.CourseCode
    AND PM.AcademicYearID            = EM.AcademicYearID
    AND PM.StartDate                  = EM.StartDate
    AND PM.LearningAimRef            = EM.LearningAimRef
    AND PM.CompletionStatusID          = EM.CompletionID
)

SELECT
    E.*,
    CAST(COALESCE(A.TotalPresent, 0)  AS INT)           AS "TotalPresent",
    CAST(COALESCE(A.TotalRequired, 0) AS INT)           AS "TotalRequired",
    CAST(COALESCE(A.AttendanceRate, 0) AS DECIMAL(5,4)) AS "AttendanceRate"
FROM Enrolments E
LEFT JOIN Attendance_Aggregated A
    ON E."EnrolmentKey" = A.EnrolmentKey