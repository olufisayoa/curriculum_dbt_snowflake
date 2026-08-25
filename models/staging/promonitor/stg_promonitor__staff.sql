SELECT 
S.StaffID,
S.StaffName
FROM {{ source('Promonitor', 'PROMONITOR_vSTAFF') }} S