WITH progress AS (
    SELECT
        "AcademicYearKey",
        "StudentKey",
        "MPKey",
        AVG("Value Added") AS avg_value_added
    FROM {{ ref('int_risk_register') }}
    GROUP BY "AcademicYearKey", "StudentKey", "MPKey"
),
progress_agg AS (
    SELECT
        "AcademicYearKey",
        "StudentKey", 
        "MPKey", 
        avg_value_added,
        CASE 
            WHEN avg_value_added < 0.0 THEN -15 
            ELSE 0
        END AS "ProgressScore"
    FROM progress
),
combined AS (
    SELECT
        pa."AcademicYearKey",
        pa."StudentKey", 
        pa."MPKey", 
        pa."ProgressScore",
        s."SafeguardingScore", 
        s."WelfareScore", 
        s."CommentsScore",
        s."BehaviourScore", 
        s."AttendanceScore"
    FROM progress_agg pa
    LEFT JOIN {{ ref('int_consolidated_student_detail') }} s ON s."StudentKey" = pa."StudentKey"
)
SELECT
    *,
    "ProgressScore" + "SafeguardingScore" + "WelfareScore" + "CommentsScore" + "BehaviourScore" + "AttendanceScore" AS "TotalRiskScore",
     CASE
        WHEN ARRAY_SIZE(
            ARRAY_COMPACT(
                ARRAY_CONSTRUCT(
                    CASE WHEN "ProgressScore" < 0 THEN 'Progress' END,
                    CASE WHEN "SafeguardingScore" < 0 THEN 'Safeguarding' END,
                    CASE WHEN "WelfareScore" < 0 THEN 'Welfare' END,
                    CASE WHEN "CommentsScore" < 0 THEN 'Comments' END,
                    CASE WHEN "BehaviourScore" < 0 THEN 'Behaviour' END,
                    CASE WHEN "AttendanceScore" < 0 THEN 'Attendance' END
                )
            )
        ) = 0 THEN 'None'
        ELSE ARRAY_TO_STRING(
            ARRAY_COMPACT(
                ARRAY_CONSTRUCT(
                    CASE WHEN "ProgressScore" < 0 THEN 'Progress' END,
                    CASE WHEN "SafeguardingScore" < 0 THEN 'Safeguarding' END,
                    CASE WHEN "WelfareScore" < 0 THEN 'Welfare' END,
                    CASE WHEN "CommentsScore" < 0 THEN 'Comments' END,
                    CASE WHEN "BehaviourScore" < 0 THEN 'Behaviour' END,
                    CASE WHEN "AttendanceScore" < 0 THEN 'Attendance' END
                )
            ), ', '
        )
    END AS "RiskFactors"
FROM combined