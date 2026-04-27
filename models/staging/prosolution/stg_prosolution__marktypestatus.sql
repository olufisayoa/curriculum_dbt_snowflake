SELECT 
"MarkTypeStatusID" AS MarkTypeStatusID,
"Description" AS Description
FROM {{ source('ProSolution', 'PROSOLUTION_MARKTYPESTATUS') }}