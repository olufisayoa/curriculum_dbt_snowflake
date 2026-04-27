SELECT
    *
FROM {{ source('ProSolution', 'PROSOLUTION_REGISTERSTUDENT') }}