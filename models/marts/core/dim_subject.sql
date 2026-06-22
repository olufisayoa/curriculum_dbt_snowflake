select 
    gcse_subject_key::INT AS "SubjectKey",
    gcse_subject_name::VARCHAR(100) AS "GCSE Subject"
from {{ ref('stg_manual_gcse_subject') }}