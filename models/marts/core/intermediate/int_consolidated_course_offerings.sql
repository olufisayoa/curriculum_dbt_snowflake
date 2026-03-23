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
         {{ dbt_utils.generate_surrogate_key(['TRIM(o.ACADEMICYEARID)', 'TRIM(o.CODE)']) }} AS CourseKey,
        o.ACADEMICYEARID::CHAR(5) AS ACADEMICYEARID,
        o.CODE::VARCHAR(50) AS COURSECODE,
        o.NAME::VARCHAR(255) AS COURSENAME,
        (o.NAME || ' (' || o.CODE || ')')::VARCHAR(355) AS FULLCOURSENAME,
        o.STARTDATE::TIMESTAMP AS STARTDATE,
        o.ENDDATE::TIMESTAMP AS ENDDATE,
        pc.PARENTCOURSECODE,
        pc.PARENTCOURSENAME,
        cs.OFFERINGSTAFF,
        o.OFFERINGID::INT AS _SOURCEPROSOLUTIONCOURSEID
    FROM {{ ref('stg_prosolution__offering') }} AS o
    LEFT JOIN CourseStaff AS cs
        ON cs.OFFERINGID = o.OFFERINGID
    LEFT JOIN ParentCourses AS pc
        ON pc.SUBOFFERINGID = o.OFFERINGID
)

SELECT
    p.CourseKey AS CourseKey,
    COALESCE(TRIM(p.ACADEMICYEARID), '00/00')::CHAR(5) AS ACADEMICYEAR,
    COALESCE(TRIM(p.COURSECODE), '-')::VARCHAR(50) AS COURSECODE,
    COALESCE(p.COURSENAME, '-')::VARCHAR(255) AS COURSENAME,
    COALESCE(p.FULLCOURSENAME, '-')::VARCHAR(355) AS FULLCOURSENAME,
    COALESCE(p.STARTDATE, '1753-01-01'::TIMESTAMP) AS STARTDATE,
    COALESCE(p.ENDDATE, '9999-12-31'::TIMESTAMP) AS ENDDATE,
    COALESCE(p.PARENTCOURSECODE, '-') AS PARENTCOURSECODE,
    COALESCE(p.PARENTCOURSENAME, '-') AS PARENTCOURSENAME,
    COALESCE(p.OFFERINGSTAFF, '-')::VARCHAR(1000) AS OFFERINGSTAFF
FROM ProsolutionOffering AS p
LEFT JOIN {{ ref('stg_onegrade__course') }} AS c
ON p.CourseKey = c.CourseKey