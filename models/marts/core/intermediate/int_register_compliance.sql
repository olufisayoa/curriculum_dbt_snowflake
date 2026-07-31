{{
    config(
        materialized='incremental',
        unique_key=['LecturerSessionID'],
        incremental_strategy='merge'
    )
}}

WITH compliance_base AS (
    SELECT
        RSL.LecturerSessionID,
        RS.RegisterSessionID,
        R.RegisterID,
		R.AcademicYearID,
		R.SID,

        
        CAST(RS.Date AS DATE) AS session_date,
        
        CAST(RS.Date AS DATETIME) + CAST(RS.StartTime AS DATETIME) AS session_start_datetime,
		CAST(RS.Date AS DATETIME) + CAST(RS.EndTime AS DATETIME) AS session_end_datetime,
		RS.Duration AS session_duration_minutes,
        
        S.FirstName AS lecturer_first_name,
        S.Surname AS lecturer_surname,
        CONCAT(S.FirstName, ', ', S.Surname) AS lecturer_full_name,

        
        MIN(RM.CreatedDate) AS first_mark_datetime,
        MAX(RM.CreatedDate) AS last_mark_datetime,

        DATEDIFF(
            MINUTE,
            CAST(RS.Date AS DATETIME) + CAST(RS.StartTime AS DATETIME),
            MIN(RM.CreatedDate)
        ) AS minutes_to_first_mark,

        CASE 
            WHEN MIN(RM.CreatedDate) IS NULL THEN 1
            WHEN DATEDIFF(
                    MINUTE,
                    CAST(RS.Date AS DATETIME) + CAST(RS.StartTime AS DATETIME),
                    MIN(RM.CreatedDate)
                 ) > 15 
            THEN 1 
            ELSE 0 
        END AS is_marked_late_over_15mins,

        COUNT(DISTINCT RM.RegisterMarkID) AS students_marked,
        COUNT(DISTINCT RST.RegisterStudentID) AS total_students_on_session,

        ROUND(
            COUNT(DISTINCT RM.RegisterMarkID) * 100.0 / 
            NULLIF(COUNT(DISTINCT RST.RegisterStudentID), 0), 
            2
        ) AS pct_students_marked

    FROM {{ ref('stg_prosolution__registersessionlecturer')}} RSL
    INNER JOIN {{ ref('stg_prosolution__registersession') }} RS 
        ON RSL.RegisterSessionID = RS.RegisterSessionID

    INNER JOIN {{ ref('stg_prosolution__register') }} R 
        ON RS.RegisterID = R.RegisterID

    LEFT JOIN {{ ref('stg_prosolution__staff') }} S
        ON RSL.StaffID = S.StaffID

    LEFT JOIN {{ ref('stg_prosolution__registerstudent') }} RST 
        ON R.RegisterID = RST.RegisterID

    LEFT JOIN {{ ref('stg_prosolution__registermark') }} RM 
        ON RM.RegisterSessionID = RS.RegisterSessionID
       AND RST.RegisterStudentID = RM.RegisterStudentID
       AND CAST(RM.CreatedDate AS DATE) = CAST(RS.Date AS DATE)


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

SELECT * 
FROM compliance_base
ORDER BY session_date DESC;