SELECT 
MC.MeetingCategoryID,
MC.MeetingCategoryName
FROM {{ source('Promonitor', 'PROMONITOR_ILP_MEETINGCATEGORY') }} MC