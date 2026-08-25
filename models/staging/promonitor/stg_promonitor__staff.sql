SELECT 
S.StaffID,
S.StaffName
FROM {{ source('Promonitor', 'PROMONITOR_VSTAFF') }} S