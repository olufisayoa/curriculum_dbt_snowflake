SELECT 
MT.MeetingTypeID,
MT.MeetingTypeName,
MT.IsObsolete,
MT.MeetingCategoryID
FROM {{ source('Promonitor', 'PROMONITOR_ILP_MEETINGTYPE') }} MT