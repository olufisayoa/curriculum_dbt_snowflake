WITH prosolution_enrolment AS (
    SELECT
        TRIM(po.AcademicYearID)  AS AcademicYearID,
        TRIM(ps.RefNo)           AS StudentRef,
        TRIM(po.Code)            AS CourseCode,
        TRIM(po.QualID)          AS LearningAimRef,
        CAST(pe.StartDate AS DATE) AS StartDate,
        pe.OfferingGroupID
    FROM CURRICULUM_DB.stg.stg_prosolution__enrolment AS pe
    JOIN CURRICULUM_DB.stg.stg_prosolution__offering  AS po ON pe.OfferingID = po.OfferingID
    JOIN CURRICULUM_DB.stg.stg_prosolution__student   AS ps ON pe.StudentDetailID = ps.StudentDetailID
)
SELECT 
        e.*,
        s.SiteID AS SiteID,
        o.OfferingID AS OfferingID,
        pen.OfferingGroupID AS OfferingGroupID,
        o.SID AS CollegeLevelCode
    FROM CURRICULUM_DB.stg.stg_onegrade__estactva AS e
    LEFT JOIN CURRICULUM_DB.stg.stg_onegrade__course AS c 
        ON e.CourseCode = c.CourseCode 
        AND e.AcademicYearID = c.AcademicYearID
    LEFT JOIN prosolution_enrolment AS pen
        ON  TRIM(pen.AcademicYearID) = TRIM(e.AcademicYearID)
        AND TRIM(pen.StudentRef)     = TRIM(e.StudentRef)
        AND TRIM(pen.CourseCode)     = TRIM(e.CourseCode)
        AND TRIM(pen.LearningAimRef) = TRIM(e.LearningAimRef)
        AND pen.StartDate      = CAST(e.StartDate AS DATE)
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__offering AS o 
        ON o.Code = c.CourseCode 
        AND o.AcademicYearID = c.AcademicYearID
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__site AS s 
        ON s.SiteID = o.SiteID
    WHERE e.CompletionID IN (1,2)