
  
    

create or replace transient table CURRICULUM_DB.int.int_register_compliance
    
    
    
    as (

WITH compliance_base AS (
    SELECT
        RSL.LecturerSessionID,
        RS.RegisterSessionID,
        R.RegisterID,
		R.AcademicYearID,
		R.SID,

        
        CAST(RS.Date AS DATE) AS session_date,

        TIMESTAMP_NTZ_FROM_PARTS(
            YEAR(RS.Date), MONTH(RS.Date), DAY(RS.Date),
            HOUR(RS.StartTime), MINUTE(RS.StartTime), SECOND(RS.StartTime)
        ) AS session_start_datetime,

        TIMESTAMP_NTZ_FROM_PARTS(
            YEAR(RS.Date), MONTH(RS.Date), DAY(RS.Date),
            HOUR(RS.EndTime), MINUTE(RS.EndTime), SECOND(RS.EndTime)
        ) AS session_end_datetime,
        
		RS.Duration AS session_duration_minutes,
        
        S.FirstName AS lecturer_first_name,
        S.Surname AS lecturer_surname,
        CONCAT(S.FirstName, ', ', S.Surname) AS lecturer_full_name,

        
        MIN(M.CreatedDate) AS first_mark_datetime,
        MAX(M.CreatedDate) AS last_mark_datetime,

        DATEDIFF(
            'minute',
            TIMESTAMP_NTZ_FROM_PARTS(
                YEAR(RS.Date), MONTH(RS.Date), DAY(RS.Date),
                HOUR(RS.StartTime), MINUTE(RS.StartTime), SECOND(RS.StartTime)
            ),
            MIN(M.CreatedDate)
        ) AS minutes_to_first_mark,

        CASE 
            WHEN MIN(M.CreatedDate) IS NULL THEN 1
            WHEN DATEDIFF(
                    'minute',
                    TIMESTAMP_NTZ_FROM_PARTS(
                        YEAR(RS.Date), MONTH(RS.Date), DAY(RS.Date),
                        HOUR(RS.StartTime), MINUTE(RS.StartTime), SECOND(RS.StartTime)
                    ),
                    MIN(M.CreatedDate)
                 ) > 15 
            THEN 1 
            ELSE 0 
        END AS is_marked_late_over_15mins,

        COUNT(DISTINCT M.RegisterMarkID) AS students_marked,
        COUNT(DISTINCT RST.RegisterStudentID) AS total_students_on_session,

        ROUND(
            COUNT(DISTINCT M.RegisterMarkID) * 100.0 / 
            NULLIF(COUNT(DISTINCT RST.RegisterStudentID), 0), 
            2
        ) AS pct_students_marked

    FROM CURRICULUM_DB.stg.stg_prosolution__registersessionlecturer RSL
    INNER JOIN CURRICULUM_DB.stg.stg_prosolution__registersession RS 
        ON RSL.RegisterSessionID = RS.RegisterSessionID

    INNER JOIN CURRICULUM_DB.stg.stg_prosolution__register R 
        ON RS.RegisterID = R.RegisterID

    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__staff S
        ON RSL.StaffID = S.StaffID

    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__registerstudent RST 
        ON R.RegisterID = RST.RegisterID

    LEFT JOIN CURRICULUM_DB.stg.stg_prosolution__registermark M 
        ON M.RegisterSessionID = RS.RegisterSessionID
       AND RST.RegisterStudentID = M.RegisterStudentID
       AND CAST(M.CreatedDate AS DATE) = CAST(RS.Date AS DATE)


    GROUP BY 
        RSL.LecturerSessionID,
        RS.RegisterSessionID,
        R.RegisterID,
		R.SID,
		R.AcademicYearID,
        RS.Date,                    
        RS.StartTime,
        RS.EndTime,
        RS.Duration,
        S.FirstName,
        S.Surname
)

SELECT 
    base.LecturerSessionID AS "LecturerSessionID",
	base.RegisterSessionID AS "RegisterSessionID",
	base.RegisterID AS "RegisterID",
	md5(cast(coalesce(cast(TRIM(base.SID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "CollegeLevelKey",
	md5(cast(coalesce(cast(TRIM(base.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "AcademicYearKey",
	base.session_date AS "Session Date",
	base.session_start_datetime AS "Session Start Date",
	base.session_end_datetime AS "Session End Date",
	base.session_duration_minutes AS "Session Duration",
	base.lecturer_full_name AS "Lecturer Name",
	base.students_marked AS "Students Marked",
	base.total_students_on_session AS "Total Students",
	base.pct_students_marked AS "Percentage Marked"
FROM compliance_base AS base
ORDER BY session_date DESC
    )
;


  