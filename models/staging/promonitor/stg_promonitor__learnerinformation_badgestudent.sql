SELECT
BS.PMStudentID,
BS.BadgeValueID,
BS.BadgeID,
BS.AuditDateCreated
FROM {{ source('Promonitor', 'PROMONITOR_LEARNERINFORMATION_BADGESTUDENT') }} BS