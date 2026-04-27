SELECT 
    *
FROM {{ source('ProSolution', 'PROSOLUTION_REGISTERSESSION') }}