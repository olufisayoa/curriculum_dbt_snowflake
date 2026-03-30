SELECT 
{{ dbt_utils.generate_surrogate_key(['TRIM(o.OFFERINGID)']) }} AS CourseKey
,o.* 
FROM {{ source('ProSolution', 'PROSOLUTION_OFFERING') }} AS o