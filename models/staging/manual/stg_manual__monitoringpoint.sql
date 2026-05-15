
WITH mp_data AS (
    SELECT 1 AS MPKey, 'Monitoring Point 1' AS MonitoringPointCode, 'MP1' AS MPCode UNION ALL
    SELECT 2, 'Monitoring Point 2', 'MP2' UNION ALL
    SELECT 3, 'Monitoring Point 3', 'MP3' UNION ALL
    SELECT 4, 'Monitoring Point 4', 'MP4' UNION ALL
    SELECT 5, 'Monitoring Point 5', 'MP5' UNION ALL
    SELECT 6, 'Final MP', 'Final VA' 
)

SELECT 
    MPKey::INT AS "MPKey",
    MonitoringPointCode::VARCHAR(20) AS "MonitoringPointCode",
    MPCode::CHAR(3) AS "MPCode"
FROM mp_data