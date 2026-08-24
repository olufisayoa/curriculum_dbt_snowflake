SELECT 
{{ dbt_utils.generate_surrogate_key(['MT.MeetingTypeID']) }} AS "MeetingTypeKey",
MT.MeetingTypeName AS "MeetingTypeName",
MC.MeetingCategoryName AS "MeetingCategoryName",
CAST(MT.IsObsolete AS BOOLEAN) AS "IsObsolete"
FROM {{ ref('stg_promonitor__ilp_meetingtype') }} MT
LEFT JOIN {{ ref('stg_promonitor_ilp_meetingcategory') }} MC ON MT.MeetingCategoryID = MC.MeetingCategoryID