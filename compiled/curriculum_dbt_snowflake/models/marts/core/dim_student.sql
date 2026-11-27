SELECT 
    SD.*,
    COALESCE(ES."IsEnrolled", 'No') AS "IsEnrolled"
FROM CURRICULUM_DB.int.int_consolidated_student_detail AS SD
LEFT JOIN CURRICULUM_DB.int.int_student_enrolment_status ES
    ON SD."StudentKey" = ES."StudentKey"