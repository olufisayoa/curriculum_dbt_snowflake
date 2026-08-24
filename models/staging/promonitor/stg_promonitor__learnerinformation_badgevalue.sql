SELECT 
BV.BadgeValueID,
BV.BadgeID,
BV.Name AS BadgeValueName,
BV.BadgeCode,
BV.IsObsolete
FROM {{ source('Promonitor', 'PROMONITOR_LEARNERINFORMATION_BADGEVALUE') }} BV