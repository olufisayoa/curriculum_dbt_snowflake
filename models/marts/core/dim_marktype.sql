WITH MarkTypeStatus AS (
SELECT 
MarkTypeStatusID,
Description
FROM {{ ref('stg_prosolution__marktypestatus')  }}
),
MarkType AS (
SELECT
MarkTypeID,
Mark,
MarkTypeDescription,
MarkTypeStatusID,
IsAuthorisedAbsence,
IsLate
FROM {{ ref('stg_prosolution__marktype')  }}
)
SELECT 
{{ dbt_utils.generate_surrogate_key(['MT.MarkTypeID']) }} AS "MarkTypeKey",
MT.Mark AS "Mark", 
MT.MarkTypeDescription AS "MarkTypeDescription",
MT.IsAuthorisedAbsence AS "IsAuthorisedAbsence",
MT.IsLate AS "IsLate",
MTS.Description AS "MarkTypeStatusDescription"
FROM MarkType MT
INNER JOIN MarkTypeStatus MTS
ON MT.MarkTypeStatusID = MTS.MarkTypeStatusID
