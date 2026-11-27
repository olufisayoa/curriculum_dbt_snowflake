SELECT 
    SD.*,
    COALESCE(ES."IsEnrolled", 'No') AS "IsEnrolled"
FROM {{ ref('int_consolidated_student_detail') }} AS SD
LEFT JOIN {{ ref('int_student_enrolment_status') }} ES
    ON SD."StudentKey" = ES."StudentKey"