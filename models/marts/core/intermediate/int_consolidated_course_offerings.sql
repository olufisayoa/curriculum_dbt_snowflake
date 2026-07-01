WITH CourseStaff AS (
    SELECT
        os.OFFERINGID,
        UPPER(LISTAGG(s.FIRSTNAME || '.' || s.SURNAME, ', ')) AS OFFERINGSTAFF
    FROM {{ ref('stg_prosolution__offeringstaff') }} AS os
    INNER JOIN {{ ref('stg_prosolution__staff') }} AS s
        ON os.STAFFID = s.STAFFID
    GROUP BY os.OFFERINGID
),

ParentCourses AS (
    SELECT
        lo.SUBOFFERINGID,
        LISTAGG(po.CODE, ', ') AS PARENTCOURSECODE,
        LISTAGG(po.NAME, ', ') AS PARENTCOURSENAME
    FROM {{ ref('stg_prosolution__linkedoffering') }} AS lo
    INNER JOIN {{ ref('stg_prosolution__offering') }} AS po
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
        cs.OFFERINGSTAFF,
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
        o.OFFERINGID::INT AS _SOURCEPROSOLUTIONCOURSEID
    FROM {{ ref('stg_prosolution__offering') }} AS o
    LEFT JOIN CourseStaff AS cs
        ON cs.OFFERINGID = o.OFFERINGID
    LEFT JOIN ParentCourses AS pc
        ON pc.SUBOFFERINGID = o.OFFERINGID
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['TRIM(p._SOURCEPROSOLUTIONCOURSEID)']) }} AS "CourseKey",
    COALESCE(TRIM(p.ACADEMICYEARID), '00/00')::CHAR(5) AS "AcademicYear",
    COALESCE(TRIM(p.COURSECODE), '-')::VARCHAR(50) AS "CourseCode",
    COALESCE(p.COURSENAME, '-')::VARCHAR(255) AS "CourseName",
    COALESCE(p.FULLCOURSENAME, '-')::VARCHAR(355) AS "FullCourseName",
    COALESCE(p.STARTDATE, '1753-01-01'::TIMESTAMP) AS "StartDate",
    COALESCE(p.ENDDATE, '9999-12-31'::TIMESTAMP) AS "EndDate",
    COALESCE(p.PARENTCOURSECODE, '-') AS "ParentCourseCode",
    COALESCE(p.PARENTCOURSENAME, '-') AS "ParentCourseName",
    COALESCE(p.OFFERINGSTAFF, '-')::VARCHAR(1000) AS "OfferingStaff",
    COALESCE(p.CourseType, '-')::VARCHAR(50) AS "CourseType"
FROM ProsolutionOffering AS p

