WITH BedeEvents AS (

    SELECT
        E.EventID,
        E.UserID,
        E.CardNumber,
        CASE
            WHEN LEFT(TRIM(U.Field10_50), 1) = '0'
            THEN 'B' || SUBSTR(TRIM(U.Field10_50), 2)
            ELSE TRIM(U.Field10_50)
        END AS StudentID,
        E.EventTime,
        to_number(to_char(E.EventTime, 'YYYYMMDD')) AS DateKey,
        E.PeripheralName,
        CASE E.PeripheralName
            WHEN 'Bede - Main - LRC Clock Sign in/Out (In)'  THEN 'IN'
            WHEN 'Bede - Main - LRC Clock Sign in/Out (Out)' THEN 'OUT'
        END AS Direction
    FROM CURRICULUM_DB.stg.stg_paxton__events AS E
    INNER JOIN CURRICULUM_DB.stg.stg_paxton__users AS U
        ON U.UserID = E.UserID
    WHERE E.UserID IS NOT NULL AND E.PeripheralName IN ('Bede - Main - LRC Clock Sign in/Out (In)', 'Bede - Main - LRC Clock Sign in/Out (Out)') 
    AND U.DepartmentName LIKE '%Students%' AND NOT U.DepartmentName LIKE '%StudentServices%' AND TRIM(U.Field10_50) NOT LIKE 'VS0%' 
    
),
PairedEvents AS (

    SELECT
        UserID,
        CardNumber,
        StudentID,
        DateKey,
        EventTime AS TapInTime,
        Direction AS CurrentDirection,
        LEAD(EventTime) OVER (
            PARTITION BY UserID, CardNumber, DateKey
            ORDER BY EventTime, EventID
        ) AS TapOutTime,
        LEAD(Direction) OVER (PARTITION BY UserID, CardNumber, DateKey ORDER BY EventTime, EventID) AS NextDirection
    FROM BedeEvents

),
AcademicYear AS (
    SELECT
        AY.AcademicYearID, AY.StartDate, AY.EndDate
    FROM CURRICULUM_DB.stg.stg_prosolution__academicyear AS AY
)
SELECT
    md5(cast(coalesce(cast(TRIM(AY.AcademicYearID) as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(TRIM(PE.StudentID) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS StudentKey,
    PE.CardNumber,
    PE.StudentID,
    PE.DateKey,
    PE.TapInTime,
    PE.TapOutTime,
    CASE 
        WHEN DATEDIFF(MINUTE, PE.TapInTime, PE.TapOutTime) > 300  THEN 5.0
        ELSE DATEDIFF(MINUTE, PE.TapInTime, PE.TapOutTime) / 60.0
    END AS DurationInHours
FROM PairedEvents PE
INNER JOIN AcademicYear AY
ON PE.TapInTime::DATE BETWEEN AY.StartDate AND AY.EndDate
WHERE PE.TapOutTime IS NOT NULL AND PE.CurrentDirection = 'IN' AND PE.NextDirection = 'OUT' AND PE.TapOutTime > PE.TapInTime