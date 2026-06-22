
WITH gcse_subject AS (
    SELECT 1 AS gcse_subject_key, 'GCSE English' AS gcse_subject_name UNION ALL
    SELECT 2, 'GCSE Maths' UNION ALL
    SELECT 3, 'Not GCSE English / GCSE Maths'

)

SELECT 
    gcse_subject_key::INT AS gcse_subject_key,
    gcse_subject_name::VARCHAR(100) AS gcse_subject_name
FROM gcse_subject