WITH UniqueEnrolments AS (
    SELECT DISTINCT
        OFFERINGID,
        OFFERINGGROUPID
    FROM CURRICULUM_DB.stg.stg_prosolution__enrolment
),
PrimaryOfferingStaff AS (
    SELECT
        OFFERINGID,
        FullName
    FROM CURRICULUM_DB.stg.stg_prosolution__offeringmainstaff
),
ParentCourses AS (
    SELECT
        lo.SUBOFFERINGID,
        LISTAGG(po.CODE, ', ') AS PARENTCOURSECODE,
        LISTAGG(po.NAME, ', ') AS PARENTCOURSENAME
    FROM CURRICULUM_DB.stg.stg_prosolution__linkedoffering AS lo
    INNER JOIN CURRICULUM_DB.stg.stg_prosolution__offering AS po
        ON po.OFFERINGID = lo.MAINOFFERINGID
    GROUP BY lo.SUBOFFERINGID
),

ProsolutionOffering AS (
    SELECT

        o.ACADEMICYEARID::CHAR(5) AS ACADEMICYEARID,
        o.CODE::VARCHAR(50) AS COURSECODE,
        o.NAME::VARCHAR(255) AS COURSENAME,
        (o.NAME || ' (' || o.CODE || ')')::VARCHAR(355) AS FULLCOURSENAME,
        o.STARTDATE::TIMESTAMP AS STARTDATE,
        o.ENDDATE::TIMESTAMP AS ENDDATE,
        pc.PARENTCOURSECODE,
        pc.PARENTCOURSENAME,
        og.Description AS OFFERINGGROUPDESCRIPTION,
        COALESCE(s.FIRSTNAME || ' ' || s.SURNAME, pos.FULLNAME) AS STAFF,
        CASE 
            WHEN O.Code LIKE '%-TX%' 
                OR O.Name LIKE '%Work Experience%' 
                OR O.Name LIKE '%Work Placement%' 
                OR O.Name LIKE '%Work Exp%' 
                OR O.Name LIKE '%work experience%'
            THEN 'Work Experience'

            WHEN O.Code LIKE '%-TU%' 
                OR O.Name LIKE '%Tutorial%' 
                OR O.Name LIKE '%tutorial%' 
            THEN 'Tutorial'

            ELSE 'Taught'
        END AS CourseType,
        o.OFFERINGID::INT AS OFFERINGID,
        og.OfferingGroupID AS OFFERINGGROUPID,
        o.QualID,
        o.GLH,
        o.Duration,
        o.StudyYear,
        o.NumberOfWeeks,
        'Level ' || la.NOTIONAL_NVQ_LEVEL_CODE AS QualificationLevel
    FROM UniqueEnrolments AS ue 
    INNER JOIN CURRICULUM_DB.stg.stg_prosolution__offering AS o
        ON ue.OfferingID=o.OfferingID
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__offeringgroup AS og
        ON og.OFFERINGID = o.OFFERINGID AND ue.OfferingGroupID = og.OfferingGroupID
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__staff AS s ON og.StaffID=s.StaffID
    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__learningaim la ON o.QualID=la.LEARNING_AIM_REF
    LEFT JOIN PrimaryOfferingStaff AS pos ON pos.OfferingID=ue.OfferingID
    LEFT JOIN ParentCourses AS pc
        ON pc.SUBOFFERINGID = o.OFFERINGID
)

SELECT
    md5(cast(coalesce(cast(p.OFFERINGID as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(p.OFFERINGGROUPID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "CourseKey",
    COALESCE(TRIM(p.ACADEMICYEARID), '00/00')::CHAR(5) AS "AcademicYear",
    COALESCE(TRIM(p.COURSECODE), '-')::VARCHAR(50) AS "CourseCode",
    COALESCE(p.COURSENAME, '-')::VARCHAR(255) AS "CourseName",
    COALESCE(p.FULLCOURSENAME, '-')::VARCHAR(355) AS "FullCourseName",
    COALESCE(p.STARTDATE, '1753-01-01'::TIMESTAMP) AS "StartDate",
    COALESCE(p.ENDDATE, '9999-12-31'::TIMESTAMP) AS "EndDate",
    COALESCE(p.PARENTCOURSECODE, '-') AS "ParentCourseCode",
    COALESCE(p.PARENTCOURSENAME, '-') AS "ParentCourseName",
    COALESCE(p.OFFERINGGROUPDESCRIPTION, '-') AS "CourseGroup",
    COALESCE(p.STAFF, '-')::VARCHAR(1000) AS "Staff",
    COALESCE(p.CourseType, '-')::VARCHAR(50) AS "CourseType",
    p.DURATION AS "Duration",
    p.GLH AS "GLH",
    p.NUMBEROFWEEKS AS "NumberOfWeeks",
    p.STUDYYEAR AS "StudyYear",
    p.QUALID AS "LearningAim",
    COALESCE(p.QualificationLevel, 'Unknown') AS "QualificationLevel"
FROM ProsolutionOffering AS p