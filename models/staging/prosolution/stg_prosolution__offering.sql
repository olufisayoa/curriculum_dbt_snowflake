SELECT 
o.* 
FROM {{ source('ProSolution', 'PROSOLUTION_OFFERING') }} AS o