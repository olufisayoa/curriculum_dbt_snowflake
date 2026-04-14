WITH  ProSolution_Master AS (
    SELECT 
        PSE.EnrolmentID                                      AS ProSolutionEnrolmentID,
        PSD.RefNo                                             AS StudentRef,
        PSO.Code                                              AS CourseCode,
        PSO.Name                                              AS CourseTitle,
        PSO.AcademicYearID                                    AS AcademicYearID,
        PSE.StartDate                                         AS StartDate,
        PSE.ExpectedEndDate                                   AS PlannedEndDate,
        PSE.ActualEndDate                                     AS ActualEndDate,
        PSC.Description                                       AS CompletionStatus,
        PSE.Grade                                             AS Grade,
        O.Description                                         AS Outcome,
        PSE.OfferingID                                        AS ProSolutionOfferingID,
        PSE.CompletionStatusID                                AS CompletionStatusID,
        PSO.QualID                                              AS QualID,
        PSE.StudentDetailID                                   AS StudentDetailID
    FROM {{ ref('stg_prosolution__enrolment') }} PSE
    INNER JOIN {{ ref('stg_prosolution__student') }} PSD   ON PSE.StudentDetailID = PSD.StudentDetailID
    INNER JOIN {{ ref('stg_prosolution__offering') }} PSO       ON PSE.OfferingID = PSO.OfferingID
    LEFT  JOIN {{ ref('stg_prosolution__completionstatus') }} PSC ON PSC.CompletionStatusID = PSE.CompletionStatusID
    LEFT  JOIN {{ ref('stg_prosolution__outcome') }} O           ON O.OutcomeID = PSE.OutcomeID
),

OneGrade_Enrichment AS (
     SELECT 
         OGE.ID                    AS OneGradeEnrolmentID,
         OGE.StudentRef,
         OGC.CourseCode,
         OGE.AcademicYearID,
         OGE.StartDate,
		 OGE.PlannedEndDate,
		 OGE.ActualEndDate,
		 OGC.CourseCode AS OneGradeCourseCode,
		 OGC.Title AS OneGradeCourseTitle,
		 OGE.VAType,
		 vla.QualType AS Cohort,
		 OGE.NotionalNVQLevel,
         OGE.WDNumDaysAfterStart,
		 ofq."QualificationLevel" AS QualificationLevel,
         OGE.AgeOn31Aug,
         OGE.LearningAimRef,
         OGE.WholeQualID,
         OGE.CourseID              AS OneGradeCourseID,
		 C.Description AS OnegradeCourseCompletionStatus
     FROM {{ ref('stg_onegrade__enrolment') }} OGE
     LEFT  JOIN {{ ref('stg_onegrade__course') }} OGC ON OGE.CourseID = OGC.ID
	 LEFT  JOIN {{ ref('stg_onegrade__completion') }} C ON C.ID=OGE.CompletionID
	 LEFT JOIN {{ ref('stg_onegrade__ofqual') }} ofq ON ofq."QualificationNumber"=OGE.LearningAimRef
	 LEFT JOIN {{ ref('stg_onegrade__learningaim') }} vla ON vla.LearningAimRef=OGE.LearningAimRef AND vla.WholeQualID=OGE.WholeQualID
     WHERE OGE.StudentRef IS NOT NULL
)

SELECT 

    {{ dbt_utils.generate_surrogate_key([
    'TRIM(PM.AcademicYearID)',   
    'TRIM(PM.StudentRef)',
    'TRIM(PM.CourseCode)',   
    'TRIM(PM.QualID)',            
    'CAST(PM.StartDate AS DATE)',      
    'CAST(PM.CompletionStatusID AS INTEGER)'                            
    ]) }} AS "EnrolmentKey",
    CAST(COALESCE(LTRIM(RTRIM(PM.AcademicYearID)), OE.AcademicYearID) AS NCHAR(5)) AS "AcademicYear",

    CAST(COALESCE(PM.StudentRef, OE.StudentRef) AS NCHAR(50)) AS "StudentID",

    CAST(COALESCE(PM.CourseCode, OE.OneGradeCourseCode) AS NVARCHAR(24)) AS "CourseCode",

    CAST(COALESCE(PM.CourseTitle, OE.OnegradeCourseTitle) AS NVARCHAR(255)) AS "CourseName",

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

	CAST(COALESCE(PM.Outcome, '-') AS NVARCHAR(100)) 
        AS "Outcome"

FROM ProSolution_Master PM
LEFT JOIN OneGrade_Enrichment OE
    ON  UPPER(LTRIM(RTRIM(PM.StudentRef)))   = UPPER(LTRIM(RTRIM(OE.StudentRef)))
    AND UPPER(LTRIM(RTRIM(PM.CourseCode)))   = UPPER(LTRIM(RTRIM(OE.CourseCode)))
    AND LTRIM(RTRIM(PM.AcademicYearID))             = LTRIM(RTRIM(OE.AcademicYearID))
	AND LTRIM(RTRIM(PM.StartDate))                   = LTRIM(RTRIM(OE.StartDate))