WITH MarkTypeStatus AS (
SELECT 
MarkTypeStatusID,
Description
FROM CURRICULUM_DB.stg.stg_prosolution__marktypestatus
),
MarkType AS (
SELECT
MarkTypeID,
Mark,
MarkTypeDescription,
MarkTypeStatusID,
IsAuthorisedAbsence,
IsLate
FROM CURRICULUM_DB.stg.stg_prosolution__marktype
)
SELECT 
md5(cast(coalesce(cast(MT.MarkTypeID as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) AS "MarkTypeKey",
MT.Mark AS "Mark", 
MT.MarkTypeDescription AS "MarkTypeDescription",
MT.IsAuthorisedAbsence AS "IsAuthorisedAbsence",
MT.IsLate AS "IsLate",
MTS.Description AS "MarkTypeStatusDescription"
FROM MarkType MT
INNER JOIN MarkTypeStatus MTS
ON MT.MarkTypeStatusID = MTS.MarkTypeStatusID